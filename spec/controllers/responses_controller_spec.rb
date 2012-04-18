require 'spec_helper'

describe ResponsesController do
  describe "POST receive_message" do
    context "multiple choice poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_multi, :phone=>'19091234567')
      end  
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, :params => fixture("sms_multi.json").read
          @poll.responses.length.should eq 1
          # Response.where
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, :params => body => fixture("sms_open.json").read
        end
      end
    end
    
    context "open-ended poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_open)
      end
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, :params => fixture("sms_open.json").read
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, :params => fixture("sms_multi.json").read
        end
      end
      
    end
  end    
end
