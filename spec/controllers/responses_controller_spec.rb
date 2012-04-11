require 'spec_helper'

describe ResponsesController do
  describe "POST receive_message" do
    context "multiple choice poll" do
      before :each do
        @poll = FactoryGirl.new(:poll_multi)
      end  
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, :params => fixture("sms_multi.json")
          # Response.where
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, :params => fixture("sms_open.json")
        end
      end
    end
    
    context "open-ended poll" do
      before :each do
        @poll = FactoryGirl.new(:poll_open)
      end
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, :params => fixture("sms_open.json")
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, :params => fixture("sms_multi.json")
        end
      end
      
    end
  end    
end
