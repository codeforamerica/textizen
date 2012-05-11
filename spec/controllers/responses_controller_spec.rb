require 'spec_helper'

describe ResponsesController do
  describe "POST receive_message" do
    context "multiple choice poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_multi, :phone=>'14153334444')
      end  
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_MULTI
          @poll.responses.length.should eq 1
          # Response.where
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
        end
      end
    end
    
    context "open-ended poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_open, :phone=>'14153334444')
      end
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
        end
      end
      
    end
  end    
end
