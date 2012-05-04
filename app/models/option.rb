class Option < ActiveRecord::Base
  attr_accessible :follow_up_id, :question_id, :text, :value
end
