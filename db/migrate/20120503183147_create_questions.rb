class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.integer :next_question_id
      t.integer :poll_id
      t.text :options
      t.string :question_type

      t.timestamps
    end
  end
end
