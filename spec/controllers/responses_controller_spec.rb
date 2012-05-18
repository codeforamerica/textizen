require 'spec_helper'

describe ResponsesController do
  describe "POST receive_message" do
    context "yn poll with y followup and next question" do
      before :each do
        @poll = FactoryGirl.create(:poll_yn, :phone=>'14153334444')
      end

      describe "valid sms y answer with no previous responses" do
        it "should save a response and send the followup" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_Y
          pending
        end
      end
      
      describe "valid sms n answer with no previous responses" do
        it "should save a response and send the next question" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_N
          pending
        end
      end

      describe "valid sms answer with previous y response" do
        it "should save a responses for the followup and send the next question" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_Y
          post :receive_message, :params => TROPO_SMS_RESPONSE_OPEN
          pending
        end
      end

      describe "valid sms answer with previous n (non-follow-up-triggering) response" do
        it "should save a response to the next question and say thanks" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_N
          post :receive_message, :params => TROPO_SMS_RESPONSE_OPEN
          pending
        end
      end

      describe "valid sms answer with two previous responses (y and anything)" do
        it "should create a new response to the next question and say thanks" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_Y
          post :receive_message, :params => TROPO_SMS_RESPONSE_OPEN
          post :receive_message, :params => TROPO_SMS_RESPONSE_OPEN
          pending
        end
      end 
    end

    context "yn poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_yn, :phone=>'14153334444')
      end
      describe "sms with valid y response" do
        it "should create a new response" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_Y
        end
      end
      describe "sms with valid yes response" do
        pending
      end
      describe "sms with valid Y response" do
        pending
      end
      describe "sms with valid n response" do
        it "should creat a new response" do
          pending
        end
      end
      describe "sms with invalid response" do
        pending "behavior to be determined"
      end
    end
    context "multiple choice poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_multi, :phone=>'14153334444')
      end  
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_MULTI
          @poll.responses.length.should eq 1
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_OPEN
        end
      end
    end
    
    context "open-ended poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_open, :phone=>'14153334444')
      end
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_OPEN
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, :params => TROPO_SMS_RESPONSE_OPEN
        end
      end
      
    end
  end    
end
