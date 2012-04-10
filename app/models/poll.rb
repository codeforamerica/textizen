class Poll < ActiveRecord::Base
  attr_accessible :end_date, :phone, :start_date, :text, :title, :poll_type, :user_id
  belongs_to :user
  has_many :responses
  
  validates :poll_type, :inclusion => { :in => %w(MULTI OPEN), :message => "%{value} is not a valid poll type" }  
  validates_uniqueness_of :phone

end
