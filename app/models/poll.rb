class Poll < ActiveRecord::Base
  attr_accessible :end_date, :phone, :start_date, :text, :title, :poll_type
  belongs_to :user
  has_many :responses
  
  validates_uniqueness_of :phone

end
