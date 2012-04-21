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
  describe "format_poll_type" do
    it "should return Open" do
      result = format_poll_type('OPEN')
      result.should == 'Open'
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

  describe "sparkline helper" do
    it "should generate a sparkline image tag" do
      @data = [10, 10, 4, 8, 12, 7, 7, 2, 0]
      @width = 100
      @height = 40
      @expected = "<img alt=\"Chart?chd=s:zzup9kkka&amp;cht=lc&amp;chs=100x40&amp;chxr=0,10,12\" class=\"\" src=\"http://chart.apis.google.com/chart?chd=s:zzUp9kkKA&amp;cht=lc&amp;chs=100x40&amp;chxr=0,10,12\" style=\"\" />"
      puts sparkline(@data, @width, @height)
      sparkline(@data, @width, @height).should == @expected
    end
  end
end
