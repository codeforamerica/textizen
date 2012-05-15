class Option < ActiveRecord::Base
  attr_accessible :follow_up_id, :question_id, :text, :value
  belongs_to :question
  has_one :follow_up, :class_name => "Question", :foreign_key => "parent_option_id"
  validates_presence_of :text, :value
end
