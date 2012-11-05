require 'csv'

class Poll < ActiveRecord::Base
  POISON_WORDS_REGEX = /ahole|anus|ash0le|ash0les|asholes|ass|Assface|assh0le|assh0lez|asshole|assholes|assholz|asswipe|azzhole|bastard|bastards|bastardz|basterds|basterdz|Biatch|bitch|bitches|BlowJob|butthole|buttwipe|c0ck|c0cks|c0k|Carpet Muncher|cawk|cawks|Clit|cock|cocks|CockSucker|cock-sucker|cum|cunt|cunts|cuntz|dick|dild0|dild0s|dildo|dildos|dyke|f u c k|f u c k e r|fag|faggot|fags|fuck|fucker|fuckin|fucking|Fukker|Fukkin|g00k|gay|gays|gayz|hell|jackoff|jap|japs|jerk-off|jisimjizm|jizz|kunt|kunts|kuntz|Lesbian|massterbait|masstrbait|masstrbate|masterbaiter|masterbate|masterbates|orgasim;|orgasm|orgasum|pecker|peenus|peinus|pen1s|penas|penis|penus|Phuck|Phuk|Phuker|Phukker|polack|Poonani|pr1ck|pussee|pussy|queer|queers|queerz|qweers|qweerz|recktum|rectum|retard|scank|schlong|screwing|semen|Sh!t|sh1t|sh1ter|sh1ts|sh1tter|sh1tz|shit|shits|shitter|Shitty|Shity|shitz|Shyt|Shyte|Shytty|Shyty|skanck|skank|skankee|skankey|skanks|Skanky|slut|sluts|Slutty|slutz|son-of-a-bitch|tit|turd|vag1na|vagiina|vagina|vaj1na|vajina|vulva|w0p|wh00r|wh0re|whore|b!\+ch|bitch|blowjob|clit|fuck|shit|ass|asshole|b!tch|b17ch|b1tch|bastard|bi+ch|c0ck|cawk|chink|clits|cock|cum|cunt|dildo|ejakulate|fatass|fcuk|fuk|fux0r|lesbian|masturbate|masterbat|masterbat3|motherfucker|s\.o\.b\.|mofo|nazi|nigga|nigger|nutsack|pussy|scrotum|sh!t|shi\+|sh!\+|slut|teets|tits|boobs|b00bs|testical|testicle|titt|jackoff|wank|whore|damn|dyke|fuck|shit|bitch|bollock|breasts|butt-pirate|cabron|Cock|cunt|dick|fag|gay|gook|hell|jizz|kike|lesbo|nigger|screw|spic|splooge|b00b|testicle|titt|twat|wank|wetback|wop/

  attr_accessible :end_date, :phone, :start_date, :title, :user_id, :questions_attributes, :group_ids, :confirmation, :public
  belongs_to :author, :class_name=> "User", :foreign_key=>"user_id"
  has_and_belongs_to_many :groups
  has_many :users, :through => :groups

  has_many :questions, :order => "sequence ASC, created_at ASC", :dependent => :destroy
  has_many :responses, :through => :questions
#  has_many :options, :through => :questions # broken
  has_many :follow_up, :through => :questions
  has_many :follow_up_options, :through => :questions
  has_many :follow_up_responses, :through => :questions
  accepts_nested_attributes_for :questions, :reject_if => :all_blank, :allow_destroy => true

# validates_uniqueness_of :phone
  before_create :set_new_phone_number
  before_destroy :destroy_phone_number


  def questions_ordered
    return self.questions.order(:sequence)
  end
  def running?
    return self.start_date < Time.now && self.end_date > Time.now
  end

  # ends a poll
  def end
    self.end_date = Time.now
  end

  # returns all responses, including from followups
  def responses_all
    return (self.responses + self.follow_up_responses).sort{|a,b| a.created_at <=> b.created_at}
  end

  # returns all questions, including followups IN ORDER
  def questions_all
    allq = []
    self.questions_ordered.each do |q|
      allq.push(q)
      f = q.get_follow_up
      allq.push(f) if f
    end
    return allq
    #return self.questions + self.follow_ups
  end

  def options_all
    #return self.options + self.follow_up_options #broken
    opts = []
    self.questions.each do |q|
      opts += q.follow_up_options
      opts += q.options
    end
    return opts
  end

  # a nice flat view of responses, sorted by first response time. TODO: use reduce instead
  # [{from: 124, responses: {0:'y', 2:'02460'}, first_response_time: , last_response_time: }]
  # [{from: 123, responses: {0:'n', 1: 'just cuz', 2: '02459'} ...}]
  def responses_flat
    _flat = []
    _hash = self.responses_all.group_by {|r| r.from}
    _hash.each do |from, responses|
      _rObj = {:from => from, :first_response_created => responses.first.created_at, :last_response_created => responses.last.created_at}
      _rObj[:texts] = {}
      responses.each{|resp| _rObj[:texts][resp.question_id] = resp.response}
      _flat.push(_rObj)
    end
    #> {"15226438959"=>[#<Response id: 55, from: "15226438959", to: nil, response: "I buy groceries IN YOUR FACE", created_at: "2012-05-24 01:37:47", updated_at: "2012-05-24 01:37:47", question_id: 40>, #<Response id: 56, from: "15226438959", to: nil, response: "I buy groceries IN YOUR FACE", created_at: "2012-05-24 01:38:26", updated_at: "2012-05-24 02:07:35", question_id: 48>]}
    return _flat
  end


  #return an array of all question headers?
  # [{id: 0, title: 'whatever', sequence: 0}]
  def question_headers
    headers = []
    self.all_questions.each do |q|
      headers.push({id: q.id, text: q.text, sequence: q.sequence})
    end
    return headers
  end

  # returns the next unanswered question for this person
  def get_next_question(phone)
    if self.questions.length > 0
      self.questions_ordered.each do |q|
        return q if q.responses.where(from: phone).length == 0
      end
    end
    false
  end

  def set_new_phone_number
    self.phone ||= get_phone_number
  end

  # recursive function to get a new phone number, making sure that it wasn't previously assigned
  # if the number was assigned to a previous (closed) poll, then it calls itself again
  # once a non-duplicate number is found, all duplicates are destroyed
  def get_phone_number(addresses_to_clear = [])
    prefix = '1215'
    unless self.groups.empty? or self.groups.first.exchange.nil? # just in case
      prefix = self.groups.first.exchange
    end

    if Rails.env == "development"
      @address = "#{prefix}"+rand(10 ** 7).to_s
    else 
      logger.info "Trying to get number for prefix #{prefix}"

      tp = TropoProvisioning.new(ENV['TROPO_USERNAME'], ENV['TROPO_PASSWORD'])
      address = tp.create_address(ENV['TROPO_APP_ID'], { :type => 'number', :prefix => prefix })

      @address = Poll.normalize_phone(address['address'])

      unless Poll.where(:phone=>@address).empty?
        addresses_to_clear.push(@address)
        return get_phone_number(addresses_to_clear)
      else
        addresses_to_clear.each do |a|
          destroy_phone_number(a)
        end
      end
    end
    puts @address
    return @address
  end

  def to_csv
    Rails.logger.info "[INFO] Converting to CSV"

    qs = self.questions_all

    csv_data = CSV.generate do |csv|
      headers = ['Timestamp:first', 'Timestamp:last']
      qs.each do |q|
        headers.push(q.text)
        unless q.options.empty?
          headers.push("#{q.text} (value)")
        end
      end
      headers.push('Area Code')
      headers.push('Phone Prefix')
      csv << headers
      self.responses_flat.each do |resp|
        r = []
        r.push(resp[:first_response_created])
        r.push(resp[:last_response_created])
        qs.each do |q|
          r.push(resp[:texts][q.id])
          unless q.options.empty?
            r.push((q.get_matching_option(resp[:texts][q.id])))
          end
        end
        r.push(resp[:from][1,3])
        r.push(resp[:from][4,3])
        csv << r
      end
    end

    csv_data
  end

  def destroy_phone_number(phone = '')
    phone = phone || self.phone
    phone = Poll.denormalize_phone(phone)
    begin
      puts 'destroy phone number'
      tp = TropoProvisioning.new(ENV['TROPO_USERNAME'], ENV['TROPO_PASSWORD'])
      tp.delete_address(ENV['TROPO_APP_ID'], phone)
    rescue
      puts 'Unable to delete number #{!$}'
    end
  end

  # returns an array of responses per day suitable for google chart time series visualization
  def time_series
    @datehash = {}
    @datearray = []
    self.responses.group_by { |s| s.created_at.beginning_of_day }
      .map{|item| {item[0].to_date.to_s => item[1].length}}
      .each{|i| @datehash[i.keys[0]] = i.values[0]}
    puts @datehash
    # if poll hasn't ended, only build time series for responses until now (dont show nil for future dates)
    if self.running?
      @range_end = Time.now
    else
      @range_end = self.end_date #otherwise, use poll end date?
    end
    self.start_date.to_date.upto(@range_end.to_date+1.days) do |day|
      @datearray << (@datehash[day.to_date.to_s] || 0)
    end
    return @datearray
  end

  # returns the time since the last response for the poll
  def time_since_last_response
    if self.responses.length > 0
      Time.now - self.responses.sort{|a,b| a.created_at <=> b.created_at}.last.created_at
    else
      return 0
    end
  end

  #CLASS METHODS

  #takes in a phone number and removes a plus if it has one
  def self.normalize_phone(phone)
    puts 'normalizing phone %s' % phone
    if phone.match(/^\+/)
      phone = phone.slice(1,11)
    end
    puts 'normalized phone %s' % phone
    return phone
  end
  #adds a plus to a phone number if it doesn't have one
  def self.denormalize_phone(phone)
    puts 'denormalizing phone %s' % phone
    unless phone.match(/^\+/)
      phone = "+%s" % phone
    end
    puts 'denormalized phone %s' % phone
    return phone
  end

  def self.get_poll_by_phone(phone)
    puts ("finding poll " + phone)
    return Poll.where(:phone=>phone)[0]
  end
end
