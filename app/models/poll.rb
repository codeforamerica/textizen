class Poll < ActiveRecord::Base
  attr_accessible :end_date, :phone, :start_date, :text, :title, :poll_type
  has_many :responses
end
