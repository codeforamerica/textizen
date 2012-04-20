class Response < ActiveRecord::Base
  attr_accessible :from, :response, :to
  belongs_to :poll

  validates_presence_of :from, :response
end
