class AddChoicesToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :choices, :text
  end
end
