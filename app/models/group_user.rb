class GroupUser < ActiveRecord::Base
  attr_accessible :group_id, :user_id
  belongs_to :user
  belongs_to :group
end
