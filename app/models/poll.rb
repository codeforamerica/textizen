class Poll < ActiveRecord::Base

  attr_accessible :end_date, :phone, :start_date, :text, :title, :poll_type, :user_id
  belongs_to :user
  has_many :responses
  
  validates :poll_type, :inclusion => { :in => %w(MULTI OPEN), :message => "%{value} is not a valid poll type" }  
  validates_uniqueness_of :phone
  before_create :set_new_phone_number
  before_destroy :destroy_phone_number


  def running?
    return self.start_date < Time.now && self.end_date > Time.now
  end

  # ends a poll
  def end
    self.end_date = Time.now
  end

  def set_new_phone_number
    puts 'set new phone number'
    self.phone = self.phone || get_phone_number
  end

  # recursive function to get a new phone number, making sure that it wasn't previously assigned
  # if the number was assigned to a previous (closed) poll, then it calls itself again
  # once a non-duplicate number is found, all duplicates are destroyed
  def get_phone_number(addresses_to_clear = [])
    puts 'get phone number'
    tp = TropoProvisioning.new(ENV['TROPO_USERNAME'], ENV['TROPO_PASSWORD'])
    address = tp.create_address(ENV['TROPO_APP_ID'], { :type => 'number', :prefix => '1415' })

    @address = Poll.normalize_phone(address['address'])

    unless Poll.where(:phone=>@address).empty?
      addresses_to_clear.push(@address)
      return get_phone_number(addresses_to_clear)
    else
      addresses_to_clear.each do |a|
        destroy_phone_number(a)
      end
    end
    puts @address
    return @address
  end

  def to_csv
    csv = self.responses[0].attributes.keys.to_csv
    self.responses.each do |r|
      csv += r.attributes.values.to_csv
    end
    return csv
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
    Time.now - self.responses.sort{|a,b| a.created_at <=> b.created_at}.last.created_at
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
