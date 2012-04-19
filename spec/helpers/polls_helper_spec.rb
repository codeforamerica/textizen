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
end
