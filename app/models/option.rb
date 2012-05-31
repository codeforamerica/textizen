class Option < ActiveRecord::Base
  attr_accessible :follow_up_id, :question_id, :text, :value, :follow_up_attributes, :follow_up
  belongs_to :question
  has_many :follow_up, :class_name => "Question", :foreign_key => "parent_option_id", :dependent => :destroy
  has_many :follow_up_responses, :through => :follow_up, :source => :responses
  has_many :follow_up_options, :through => :follow_up, :source => :options
  validates_presence_of :text, :value

  accepts_nested_attributes_for :follow_up, :reject_if => :all_blank, :allow_destroy => true

  # determines if a response matched the option, with handling for yes/y/No/n 
  def match?(text)
    puts "matching #{text} against #{self.value} or #{self.text}"
    if text
      if self.value[0].match(/(y|n)/) && text[0].downcase.match(self.value)
        return true
      end
      if text.downcase.strip == self.value.downcase.strip
        puts "matched #{self.value}"
        return true
      elsif text.downcase.match(self.text.downcase)
        puts "matched #{self.text}"
        return true
      end
    end
    puts 'no match'
    false
  end  
end
