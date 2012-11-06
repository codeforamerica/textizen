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
        q = FactoryGirl.create(:question_with_follow_up, :poll => poll)

        poll.questions_all.should include(q)
        poll.questions_all.should include(q.get_follow_up)
      end
    end

    describe "#responses_all" do
      it "returns all responses associated with questions and follow ups" do
        q = FactoryGirl.create(:question_with_responses, :poll => poll)

        responses = poll.responses_all
        responses.length.should == 1
        responses.first.class.should == Response
      end
    end

    describe "#options_all" do
      it "returns all options associated with questions and follow ups" do
        q = FactoryGirl.create(:question_yn, :poll => poll)

        opts = poll.options_all
        opts.length.should == 4
        opts.first.class.should == Option
      end
    end

    describe "#responses_flat" do
      it "organizes the responses for a poll by number" do
        q = FactoryGirl.create(:question_with_responses, :poll => poll)

        res = poll.responses_flat
        res.length.should == 1
        res[0][:from].should == Response.first.from
        res[0][:texts].should_not be_nil
        res[0][:first_response_time].should == res[0][:last_response_time]
      end
    end

    describe "#question_headers" do
      it "returns the header information for all of the questions attached to a poll" do
        q = FactoryGirl.create(:question_with_follow_up, :poll => poll)

        head = poll.question_headers
        head.length.should == 2
        head[0][:id].should == q.id
        head[0][:text].should == q.text
      end
    end

    describe "#time_since_last_response" do
      context "poll has responses" do
        it "returns the time since the poll last recieved a response" do
          q = FactoryGirl.create(:question_with_responses, :poll => poll)

          t = poll.time_since_last_response
          t.should > 0
        end
      end

      context "poll has no responses" do
        it "returns 0" do
          poll.time_since_last_response.should == 0
        end
      end
    end
  end


  describe "phone number assignment and disassignment" do
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

    describe "#destroy_phone_number" do
      pending
    end
  end


  describe "export methods" do
    describe "#to_csv" do
      it "generates a csv file with responses" do
        q = FactoryGirl.create(:question_with_responses, :poll => poll)
        r1 = q.responses.first
        headers = ['Timestamp:first', 'Timestamp:last', q.text, "Area Code", "Phone Prefix"]
        row1 = [r1.created_at.to_s, r1.created_at.to_s, r1[:response], r1[:from][1,3], r1[:from][4,3]]

        csv = CSV.parse(poll.to_csv)

        csv.class.should == Array
        csv[0].should == headers
        csv[1].should == row1
      end

      it "includes options in csv" do
        q = FactoryGirl.create(:question_yn, :poll => poll)
        r1 = FactoryGirl.create(:response_y, :question => q)
        headers = ['Timestamp:first', 'Timestamp:last', q.text, q.text + " (value)", "Area Code", "Phone Prefix"]

        csv = CSV.parse(poll.to_csv)

        csv[0].should == headers
      end
    end

    describe "#time_series" do
      context "running poll" do
        it "returns an array of responses per day since the poll began" do
          q = FactoryGirl.create(:question_with_responses, :poll => poll)

          series = poll.time_series

          series.length.should == 9
          6.times do |i|
            series[i].should == 0
          end
          series[7].should == 1
        end
      end

      context "poll has ended" do
        it "returns an array of responses per day for the poll's duration" do
          q = FactoryGirl.create(:question_with_responses, :poll => poll)
          poll.update_attribute(:end_date, Time.now - 2.days)

          series = poll.time_series

          series.length.should == 7
        end
      end
    end
  end
end
