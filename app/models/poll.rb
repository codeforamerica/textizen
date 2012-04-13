class Poll < ActiveRecord::Base
  attr_accessible :end_date, :phone, :start_date, :text, :title, :poll_type, :user_id
  belongs_to :user
  has_many :responses
  
  validates :poll_type, :inclusion => { :in => %w(MULTI OPEN), :message => "%{value} is not a valid poll type" }  
  validates_uniqueness_of :phone
  before_create :set_new_phone_number
  before_destroy :destroy_phone_number

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

    @address = normalize_phone(address['address'])

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

  def destroy_phone_number(phone = '')
    phone = phone || self.phone
    puts 'destroy phone number'
    tp = TropoProvisioning.new(ENV['TROPO_USERNAME'], ENV['TROPO_PASSWORD'])
    tp.delete_address(ENV['TROPO_APP_ID'], phone)
  end

  def normalize_phone(phone)
    # puts 'normalizing phone %s' % phone
    if phone.match(/^\+/)
      phone = phone.slice(1,11)
    end
  
    return phone
  end



end
