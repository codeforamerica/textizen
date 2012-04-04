class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :from
      t.string :to
      t.text :response
      t.integer :poll_id
      t.timestamps
    end
  end
end
