class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
