class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :text
      t.integer :question_id
      t.string :value
      t.integer :follow_up_id

      t.timestamps
    end
  end
end
