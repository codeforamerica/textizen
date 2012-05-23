class Response < ActiveRecord::Base
  attr_accessible :from, :response, :to, :question_id, :sequence
  belongs_to :question

  validates_presence_of :from, :response
end
