class Group < ActiveRecord::Base
  attr_accessible :name, :poll_ids, :user_ids, :users
  has_and_belongs_to_many :users
  has_and_belongs_to_many :polls
  #accepts_nested_attributes_for :users, :polls
end
