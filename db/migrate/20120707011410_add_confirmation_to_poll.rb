class AddConfirmationToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :confirmation, :text
  end
end
