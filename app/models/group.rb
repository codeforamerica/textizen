class Group < ActiveRecord::Base
  require 'open-uri'
  attr_accessible :name, :poll_ids, :user_ids
  has_and_belongs_to_many :polls
  has_many :group_users
  has_many :users, :through => :group_users

  after_save :update_polls
  def update_polls
    unless poll_ids.nil?
      self.polls do |poll|
        poll.destroy unless poll_ids.include?(poll.id) # first delete all removed groups
      end
    end
  end

  def save_users_by_emails(emails)
    errors = []
    puts "**Saving emails**"
    puts emails
    emails.each do |email|
      unless email.blank?
        user = User.where(email: email)
        if user.present?
          users << user
        else
          errors << "User #{email} not found"
        end
      end
    end
    puts errors
    return errors
  end

  def get_exchanges
    json = open("https://api.tropo.com/v1/exchanges", :http_basic_authentication=>[ENV['TROPO_USERNAME'],ENV['TROPO_PASSWORD']]).read
    result = JSON.parse(json).find_all{|item| item["smsEnabled"]==true}
  end
end
