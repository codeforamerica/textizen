class Question < ActiveRecord::Base
  attr_accessible :poll_id, :question_type, :text, :parent_option_id
  has_many :responses
  has_many :options

  belongs_to :poll

  validates :question_type, :inclusion => { :in => %w(MULTI OPEN YN), :message => "%{value} is not a valid poll type" }  
  validates_presence_of :poll_id, :question_type
end
