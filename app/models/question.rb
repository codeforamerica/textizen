class Question < ActiveRecord::Base
  attr_accessible :next_question_id, :options, :poll_id, :question_type, :text
end
