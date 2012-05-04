class AddSequenceToQuestion < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.integer :sequence
      t.remove :next_question_id
      t.integer :parent_option_id
      
    end
  end
end
