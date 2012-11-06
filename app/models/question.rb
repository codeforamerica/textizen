class Question < ActiveRecord::Base
  POISON_WORDS_REGEX = /(\b(ahole|anus|ash0le|ash0les|asholes|Assface|assh0le|assh0lez|asshole|assholes|assholz|asswipe|azzhole|bastard|bastards|bastardz|basterds|basterdz|Biatch|bitch|bitches|BlowJob|butthole|buttwipe|c0ck|c0cks|c0k|Carpet Muncher|cawk|cawks|Clit|cock|cocks|CockSucker|cock-sucker|cum|cunt|cunts|cuntz|dick|dild0|dild0s|dildo|dildos|dyke|f u c k|f u c k e r|fag|faggot|fags|fuck|fucker|fuckin|fucking|Fukker|Fukkin|g00k|gay|gays|gayz|hell|jackoff|jap|japs|jerk-off|jisimjizm|jizz|kunt|kunts|kuntz|Lesbian|massterbait|masstrbait|masstrbate|masterbaiter|masterbate|masterbates|orgasim;|orgasm|orgasum|pecker|peenus|peinus|pen1s|penas|penis|penus|Phuck|Phuk|Phuker|Phukker|polack|Poonani|pr1ck|pussee|pussy|queer|queers|queerz|qweers|qweerz|recktum|rectum|retard|scank|schlong|screwing|semen|Sh!t|sh1t|sh1ter|sh1ts|sh1tter|sh1tz|shit|shits|shitter|Shitty|Shity|shitz|Shyt|Shyte|Shytty|Shyty|skanck|skank|skankee|skankey|skanks|Skanky|slut|sluts|Slutty|slutz|son-of-a-bitch|tit|turd|vag1na|vagiina|vagina|vaj1na|vajina|vulva|w0p|wh00r|wh0re|whore|b!\+ch|bitch|blowjob|clit|fuck|shit|ass|asshole|b!tch|b17ch|b1tch|bastard|bi+ch|c0ck|cawk|chink|clits|cock|cum|cunt|dildo|ejakulate|fatass|fcuk|fuk|fux0r|lesbian|masturbate|masterbat|masterbat3|motherfucker|s\.o\.b\.|mofo|nazi|nigga|nigger|nutsack|pussy|scrotum|sh!t|shi\+|sh!\+|slut|teets|tits|boobs|b00bs|testical|testicle|titt|jackoff|wank|whore|damn|dyke|fuck|shit|bitch|bollock|breasts|butt-pirate|cabron|Cock|cunt|dick|fag|gay|gook|hell|jizz|kike|lesbo|nigger|screw|spic|splooge|b00b|testicle|titt|twat|wank|wetback|wop))|fuck/i

  attr_accessible :poll_id, :question_type, :text, :parent_option_id, :sequence, :options_attributes, :follow_up_options_attributes

  has_many :responses
  has_many :options, :dependent => :destroy
  has_many :follow_up, :through => :options
  has_many :follow_up_options, :class_name => "Option", :foreign_key => "question_id", :dependent => :destroy
  has_many :follow_up_responses, :through => :options
  accepts_nested_attributes_for :options, :follow_up_options, :reject_if => :all_blank, :allow_destroy => true


  belongs_to :poll
  belongs_to :option, :foreign_key => "parent_option_id"

  validates :question_type, :inclusion => { :in => %w(MULTI OPEN YN), :message => "%{value} is not a valid question type" }  
  validates_presence_of :question_type#, :poll_id
  validates_presence_of :text

  scope :in_order, order(:sequence)

  def get_matching_option(response)
    return false unless response
    self.options.each do |o|
     return o.text if o.match?(response)
    end
    false
  end


  #follow up question methods
  def get_follow_up
    if self.options.length > 0
      self.options.each do |o|
        return o.follow_up[0] unless o.follow_up.blank?
      end
    end
    return false
  end

  # determines if a follow_up was triggered by a past response
  def follow_up_triggered?(phone)
    follow = self.get_follow_up
    response = self.responses.where(:from=>phone).last
    if follow && response
      return true if follow.parent_option.match?(response.response)
    end
    false
  end

  def send_follow_up?(response)
    follow = self.get_follow_up
    if follow
      return true if follow.parent_option.match?(response)
    end
    false
  end


  def valid_response?(response)
    return true if self.open?
    return true if self.options.any? { |o| o.match?(response) }
    false
  end

  def parent_option
    Option.find(self.parent_option_id)
  end


  #question type helpers
  def multi?
    self.question_type == 'MULTI'
  end

  def yn?
    self.question_type == 'YN'
  end

  def open?
    self.question_type == 'OPEN'
  end

  def answered?(from)
    self.responses.where(from: from).length > 0
  end


  def header
    { id: id, text: text, sequence: sequence }
  end

  #returns a nicely formatted string for sending via sms
  def to_sms
    ret = "#{self.text} "
    if self.question_type == 'YN'
      ret += 'Reply with Yes or No'
    elsif self.question_type == 'MULTI'
      ret << 'Reply with letter: '
      opts = []
      self.options.each do |o|
        opts << "#{o.value.upcase} #{o.text}"
      end
      ret << opts.join(' / ')
    end
    return ret
  end

  def response_histogram
    no_match_text = "Unmatched"
    excludes = [false," ","","a","about","above","after","again","against","all","am","an","and","any","are","aren't","as","at","be","because","been","before","being","below","between","both","but","by","can't","cannot","could","couldn't","did","didn't","do","does","doesn't","doing","don't","down","during","each","few","for","from","further","had","hadn't","has","hasn't","have","haven't","having","he","he'd","he'll","he's","her","here","here's","hers","herself","him","himself","his","how","how's","i","i'd","i'll","i'm","i've","if","in","into","is","isn't","it","it's","its","itself","let's","me","more","most","mustn't","my","myself","no","nor","not","of","off","on","once","only","or","other","ought","our","ours","ourselves","out","over","own","same","shan't","she","she'd","she'll","she's","should","shouldn't","so","some","such","than","that","that's","the","their","theirs","them","themselves","then","there","there's","these","they","they'd","they'll","they're","they've","this","those","through","to","too","under","until","up","very","was","wasn't","we","we'd","we'll","we're","we've","were","weren't","what","what's","when","when's","where","where's","which","while","who","who's","whom","why","why's","with","won't","would","wouldn't","you","you'd","you'll","you're","you've","your","yours","yourself","yourselves"]
    r = self.responses
    if r.length > 0
      # create an array with all the words from all the responses
      if self.options.empty?
        words = r.map{ |rs| rs.response.downcase.split(/[^A-Za-z0-9\-]/)}.flatten
      else
        words = r.map{ |rs| self.get_matching_option(rs.response) }
      end

      # reduce the words array to a set of word => frequency pairs
      hist = words.reduce(Hash.new(0)){|set, val| set[val] += 1; set}
      # sort the hash (into an array) by frequency, descending
      hist_sorted = hist.sort{|a,b| b[1] <=> a[1]}

      if self.options.empty?
        histogram = hist_sorted.select{|i| !excludes.include?(i[0]) && i[0].length > 1 && !i[0].match(POISON_WORDS_REGEX)}
      else
        histogram = hist_sorted.map do |i|
          i[0] = i[0] ? i[0] : no_match_text
          i
        end
      end

      # return the histogram after filtering out excluded words
      return histogram
    end
  end


end
