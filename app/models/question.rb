class Question < ActiveRecord::Base
  attr_accessible :poll_id, :question_type, :text, :parent_option_id, :sequence, :options_attributes
  has_many :responses
  has_many :options, :dependent => :destroy
  has_many :follow_up, :through => :options
  has_many :follow_up_options, :through => :options 
  has_many :follow_up_responses, :through => :options
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true


  belongs_to :poll
  belongs_to :option, :foreign_key => "parent_option_id"

  validates :question_type, :inclusion => { :in => %w(MULTI OPEN YN), :message => "%{value} is not a valid question type" }  
  validates_presence_of :question_type#, :poll_id
  
  def get_follow_up
    if self.options.length > 0
      self.options.each do |o|
        return o.follow_up[0] unless o.follow_up.blank?
      end
    end
    return false
  end

  def get_matching_option(response)
    self.options.each do |o|
      if o.match?(response)
        return o.text
      end
    end
    false
  end

  def response_histogram
    excludes = ['in','i','or','and','of','at', ' ']
    r = self.responses
    puts "response histogramming time: #{responses}"
    if r.length > 0
      # create an array with all the words from all the responses
      words = r.map{ |rs| rs.response.downcase.split(/[^A-Za-z\-]/)}.flatten
      unless self.options.empty?
        words.map!{ |w| self.get_matching_option(w) }
      end
      
      # reduce the words array to a set of word => frequency pairs
      hist = words.reduce(Hash.new(0)){|set, val| set[val] += 1; set}
      # sort the hash (into an array) by frequency, descending
      hist_sorted = hist.sort{|a,b| b[1] <=> a[1]}
      puts "hist_sorted #{hist_sorted}"
      
      # return the histogram after filtering out excluded words
      return hist_sorted.select{|i| !excludes.include?(i[0])}
    end
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

  def answered?(from)
    return self.responses.where(from: from).length > 0
  end

  #returns a nicely formatted string for sending via sms
  def to_sms
    ret = "#{self.text} "
    if self.question_type == 'YN'
      ret += 'Reply with Yes or No'
    elsif self.question_type == 'MULTI'
      ret << 'Reply with letter: '
      opts = []
      self.options.each do |o|
        opts << "#{o.value.upcase} #{o.text}"
      end
      ret << opts.join(' / ')
    end
    return ret
  end
end
