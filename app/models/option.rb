class Option < ActiveRecord::Base
  attr_accessible :follow_up_id, :question_id, :text, :value, :follow_up_attributes, :follow_up
  belongs_to :question
  has_one :follow_up, :class_name => "Question", :foreign_key => "parent_option_id", :dependent => :destroy
  has_many :follow_up_responses, :through => :follow_up, :source => :responses
  validates_presence_of :text, :value

  accepts_nested_attributes_for :follow_up, :reject_if => :all_blank, :allow_destroy => true

  # determines if a response matched the option, with handling for yes/y/No/n 
  def match?(text)
    puts "matching #{text} against #{self.value} or #{self.text}"
    if text
      if text[0].downcase.match(self.value)
        return true
      elsif text.downcase.match(self.text)
        return true
      end
    end
    false
  end  
end
