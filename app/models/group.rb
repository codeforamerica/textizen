class Group < ActiveRecord::Base
  attr_accessible :name, :poll_ids, :user_ids
  has_and_belongs_to_many :polls
  has_many :group_users
  has_many :users, :through => :group_users

  #accepts_nested_attributes_for :users, :polls
end
