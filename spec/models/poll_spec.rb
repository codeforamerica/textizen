require 'spec_helper'

describe Poll do

  let(:poll){ FactoryGirl.create(:poll) }

  it { should belong_to(:author) }
  it { should have_many(:users) }
  it { should have_and_belong_to_many(:groups) }
  it { should have_many(:questions) }
  it { should have_many(:responses) }
  it { should have_many(:follow_up) }
  it { should have_many(:follow_up_options) }
  it { should have_many(:follow_up_responses) }

  describe "validate phone number uniqueness" do
    pending
  end

  describe "class methods" do
    describe ".normalize_phone" do
      it "gets rid of extra characters in phone number" do
        result = Poll.normalize_phone('+16661231234')
        result.should == '16661231234'
      end
    end

    describe ".denormalize_phone" do
      it "adds a + to the phone number" do
        result = Poll.denormalize_phone('16661231234')
        result.should == '+16661231234'
      end
    end

    describe ".get_poll_by_phone" do
      it "returns the poll matching that phone number" do
        phone = '16172223333'
        poll.update_attribute(:phone, phone)
        Poll.get_poll_by_phone(phone).should == poll
      end
    end
  end



  describe "#running?" do
    it "returns true for an open poll" do
      poll.running?.should be_true
    end

    it "returns false for a closed poll" do
      poll = FactoryGirl.create(:poll_ended)
      poll.running?.should be_false
    end
  end

  describe "#end" do
    it "closes the poll" do
      poll.running?.should be_true
      poll.end
      poll.running?.should be_false
    end
  end

  describe "relationship methods" do
    describe "#questions_all" do
      it "returns all questions and follow ups associated with a poll" do
        q = FactoryGirl.create(:question_with_follow_up)
        poll.questions << q
        poll.save

        poll.questions_all.should include(q)
        poll.questions_all.should include(q.get_follow_up)
      end
    end

    describe "#responses_all" do
      it "returns all responses associated with questions and follow ups" do
        q = FactoryGirl.create(:question_with_responses)
        poll.questions << q
        poll.save

        responses = poll.responses_all
        responses.length.should == 1
        responses.first.class.should == Response
      end
    end

    describe "#options_all" do

    end

    describe "#responses_flat" do

    end

    describe "#question_headers" do

    end
  end


  describe "phone number assignment" do
    before :each do 
      stub_request(:get, "https://api.tropo.com/v1/users/").
         with(:headers => {'Content-Type'=>'application/json'}).
         to_return(:status => 200, :body => '{"dust": "dust"}', :headers => {})
      stub_request(:post, "https://api.tropo.com/v1/applications//addresses").
         with(:body => "{\"type\":\"number\",\"prefix\":\"1215\"}",
              :headers => {'Content-Type'=>'application/json'}).
         to_return(:status => 200, :body => fixture("tropo_number_response.json"), :headers => {'Content-Type'=>'application/json'})
    end

    describe "#get_phone_number" do
      it "gets a phone number from tropo" do
        result = poll.get_phone_number

        result.should == '14075551234'
      end
    end

    it "assigns a tropo phone number if one is not set" do
      p = Poll.create
      p.phone.should == "14075551234"
    end

    it "respects passed-in phone number parameters" do
      @poll = FactoryGirl.create(:poll, :phone=>"14151112222")
      @poll.phone.should == "14151112222"
    end
  end
end
