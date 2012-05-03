class Response < ActiveRecord::Base
  attr_accessible :from, :response, :to
  belongs_to :question

  validates_presence_of :from, :response
end
