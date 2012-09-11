class Group < ActiveRecord::Base
  require 'open-uri'
  attr_accessible :name, :poll_ids, :user_ids, :exchange
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

  def save_users_by_emails(emails, current_user = nil)
    puts "**Saving emails**"
    puts emails
    emails.each do |email|
      unless email.blank?
        user = User.where(:email => email)
        if user.present?
          users << user
        else
          u = User.invite!({:email => email}, current_user)
          u.update_attributes(:role => "editor")
          self.users << u
        end
      end
    end
  end
  def get_exchanges
    begin
      json = open("https://api.tropo.com/v1/exchanges", :http_basic_authentication=>[ENV['TROPO_USERNAME'],ENV['TROPO_PASSWORD']]).read
      result = JSON.parse(json).find_all{|item| item["smsEnabled"]==true and item["country"] == "United States" } # no canada for now
      result.sort_by! {|x| x['prefix']}
      result_hash = result.reduce(Hash.new()) do |set, val| # concatenate all cities and combine duplicate area codes
        unless set[val['prefix']].nil? # not added to set yet, no duplicates
          unless set[val['prefix']]['city'].casecmp(val['city']) == 0 # unless the cities are the same already (returns 0 if two strings match, case insensitive
            set[val['prefix']]['city'] << ", #{val['city']}"
          end
        else # not added to set yet, add it
          set[val['prefix']] = val
        end
        set
      end
      result_hash.map do |j,i|
        i['label'] = "#{i['prefix'][1,3]} - #{i['city']}, "
        i['label'] << "#{i['state']}" if !i['state'].blank? # just in case
        # i['label'] << "#{i['country']}"
        i
      end
    rescue Exception=>e
      result_hash = {'1415' => {label: '415 - San Francisco', prefix: '1415'}}
    ensure
      return result_hash
    end
  end
end
