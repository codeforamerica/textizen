class CreateGroupsUsers < ActiveRecord::Migration
  def change
    create_table :groups_users, :id => false do |t|
      t.integer :group_id
      t.integer :user_id
    end

    create_table :groups_polls, :id => false do |t|
      t.integer :group_id
      t.integer :poll_id
    end
  end
end
