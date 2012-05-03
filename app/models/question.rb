class Question < ActiveRecord::Base
  attr_accessible :next_question_id, :options, :poll_id, :question_type, :text
  has_many :responses
  has_one :next_question, :class_name => "Question", :foreign_key => "next_question_id"
  belongs_to :poll

  validates :question_type, :inclusion => { :in => %w(MULTI OPEN YN), :message => "%{value} is not a valid poll type" }  
 
end
