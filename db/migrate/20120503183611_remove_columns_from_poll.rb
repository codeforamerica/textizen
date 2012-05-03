class RemoveColumnsFromPoll < ActiveRecord::Migration
  def up
    change_table :polls do |t|
      t.remove :text
      t.remove :poll_type
      t.remove :choices
    end
  end

  def down
    change_table :polls do |t|
      t.text :text
      t.string :poll_type
      t.text :choices
    end
  end
end
