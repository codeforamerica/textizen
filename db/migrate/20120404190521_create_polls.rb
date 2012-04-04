class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.text :text
      t.string :phone
      t.datetime :start_date
      t.datetime :end_date
      t.string :poll_type

      t.timestamps
    end
  end
end
