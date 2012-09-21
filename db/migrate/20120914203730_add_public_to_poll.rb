class AddPublicToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :public, :boolean
  end
end
