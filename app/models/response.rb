class Response < ActiveRecord::Base
  attr_accessible :from, :response, :to
  belongs_to :poll
end
