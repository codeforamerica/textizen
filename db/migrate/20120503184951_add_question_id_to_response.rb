class AddQuestionIdToResponse < ActiveRecord::Migration
  def change
    change_table :responses do |t|
      t.remove :poll_id
      t.integer :question_id
    end
  end
end
