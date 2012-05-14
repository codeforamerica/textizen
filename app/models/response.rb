class Response < ActiveRecord::Base
  attr_accessible :from, :response, :to, :question_id
  belongs_to :question

  validates_presence_of :from, :response, :question_id
end
