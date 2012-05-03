class Question < ActiveRecord::Base
  attr_accessible :next_question_id, :options, :poll_id, :question_type, :text
  has_many :responses
  belongs_to :poll

  validates :question_type, :inclusion => { :in => %w(MULTI OPEN), :message => "%{value} is not a valid poll type" }  
 
end
