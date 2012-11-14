require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PollsHelper do

  let(:poll){ FactoryGirl.create(:poll) }

  describe "format_poll_type" do
    it "should return Open" do
      result = format_poll_type('OPEN')
      result.should == 'Open Answer'
    end
    it "should return Multiple Choice" do
      result = format_poll_type('MULTI')
      result.should == 'Multiple Choice'
    end
    it "should return nothing" do
      result = format_poll_type('Something else')
      result.should == ''
    end
  end

  describe "#format_poll_running" do
    it "returns whether the poll is running formatted as a string" do
      format_poll_running(poll).should == "Live"
    end
  end

  describe "#format_poll_date" do
    it "returns a formatted version of the date" do
      date = Date.new(2001, 10, 5)

      format_poll_date(date).should == "10/05/01"
    end
  end

  describe "#format_poll_ran_dates" do
    it "returns the length of time the poll ran formatted as a string" do
      format_poll_ran_dates(poll).should =~ /Running /
    end
  end

  describe "word histogram helper" do
    it "should generate a word histogram hash for a poll's responses" do
      poll = FactoryGirl.create(:poll_with_responses)

      hist = html_histogram(poll.time_series)
    end
  end


  describe "sparkline helper" do
    it "should generate a sparkline image tag" do
      @data = [10, 10, 4, 8, 12, 7, 7, 2, 0]
      @width = 100
      @height = 40
      @expected = "<img alt=\"Chart?chf=bg,s,00000000&amp;chd=s:zzup9kkka&amp;cht=ls&amp;chs=100x40&amp;chxr=0,10,12\" class=\"\" src=\"http://chart.apis.google.com/chart?chf=bg,s,00000000&amp;chd=s:zzUp9kkKA&amp;cht=ls&amp;chs=100x40&amp;chxr=0,10,12\" style=\"\" />"

      sparkline(@data, @width, @height).should == @expected
    end
  end

  describe "date helper" do
    it "should parse as seconds" do
      result = format_time(59)
      result.should == "59 seconds"
    end
    it "should pluralize seconds" do
      result = format_time(1.43)
      result.should == "1 second"
    end
    it "shuld parse as minutes" do
      result = format_time(123)
      result.should == "2 minutes"
    end
    it "shuld pluralize minutes" do
      result = format_time(89)
      result.should == "1 minute"
    end
    it "should parse as hours" do
      result = format_time(60*60*3 + 5.122)
      result.should == "3 hours"
    end
    it "should pluralize hours" do
      result = format_time(60*60 + 5.122)
      result.should == "1 hour"
    end
    it "should parse as days" do
      result = format_time(60*60*24*2 + 5.122)
      result.should == "2 days"
    end
    it "should pluraliz days" do
      result = format_time(60*60*24*1 + 5.122)
      result.should == "1 day"
    end
  end

end
