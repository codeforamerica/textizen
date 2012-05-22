class Question < ActiveRecord::Base
  attr_accessible :poll_id, :question_type, :text, :parent_option_id, :sequence, :options_attributes
  has_many :responses
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true


  belongs_to :poll
  belongs_to :option, :foreign_key => "parent_option_id"

  validates :question_type, :inclusion => { :in => %w(MULTI OPEN YN), :message => "%{value} is not a valid question type" }  
  validates_presence_of :question_type, :poll_id
  
  def get_follow_up
    if self.options.length > 0
      self.options.each do |o|
        return o.follow_up if o.follow_up
      end
    end
    return false
  end

  # determines if a follow_up was triggered by a past response
  def follow_up_triggered?(phone)
    @follow = self.get_follow_up
    @response = self.responses.where(:from=>phone).last
    if @follow && @response
      return true if @follow.parent_option.match?(@response.response)
    end
    false
  end

  def send_follow_up?(response)
    @follow = self.get_follow_up
    if @follow
      return true if @follow.parent_option.match?(response)
    end
    false
  end

  def valid_response?(response)
    if self.question_type == 'OPEN'
      return true
    else
      self.options.each do |o|
        return true if o.match?(response)
      end
    end
    false
  end

  def parent_option
    Option.find(self.parent_option_id)
  end
  
  def multi?
    return self.question_type == 'MULTI'
  end

  def yn?
    return self.question_type == 'YN'
  end

  def open?
    return self.question_type == 'OPEN'
  end

end
