class CreateGroupsPolls < ActiveRecord::Migration
  def change
    create_table :groups_polls, :id => false do |t|
      t.integer :group_id
      t.integer :poll_id
    end
  end
end
