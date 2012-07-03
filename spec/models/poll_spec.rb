require 'spec_helper'

describe Poll do

  it { should have_many(:questions) }
  it { should have_many(:responses) }
  it { should belong_to(:user) }
#  it { should authenticate_user }
  


  describe "check get_next_question" do
    pending
  end

  describe "check phone number normalizer" do
    it "should return 16661231234" do
      result = Poll.normalize_phone('+16661231234')
      result.should == '16661231234'
    end
  end

  describe "check phone number denormalizer" do
    it "should return +16661231234" do
      result = Poll.denormalize_phone('16661231234')
      result.should == '+16661231234'
    end
  end

  describe "check poll running function" do
    it "should return true for an open poll" do
      @poll = FactoryGirl.create(:poll)
      @poll.running?.should be_true
    end
    it "should return false for a closed poll" do
      @poll = FactoryGirl.create(:poll_ended)
      @poll.running?.should be_false
    end
  end

  describe "check get_poll_by_phone" do
    it "should find a poll by phone number" do
      @phone = '16172223333'
      @poll = FactoryGirl.create(:poll, :phone=>@phone)
      Poll.get_poll_by_phone(@phone).should_not be_nil
    end
  end

  describe "check poll ender" do
    it "should end the poll" do
      @poll = FactoryGirl.create(:poll)
      @poll.running?.should be_true
      @poll.end
      @poll.running?.should be_false
    end
  end


  describe "check phone assignment and uniqueness" do

    before(:each) do
      @poll = FactoryGirl.create(:poll)
    end
    
    it { should validate_uniqueness_of(:phone) }
    
    it "should get a phone number from tropo" do
      @number_response = '
        {
            "href":"https://api.tropo.com/v1/applications/123456/addresses/number/+14075551234"
        }'
      stub_request(:get, "https://api.tropo.com/v1/users/").
         with(:headers => {'Content-Type'=>'application/json'}).
         to_return(:status => 200, :body => '{"dust": "dust"}', :headers => {})
      stub_request(:post, "https://api.tropo.com/v1/applications//addresses").
         with(:body => "{\"type\":\"number\",\"prefix\":\"1415\"}",
              :headers => {'Content-Type'=>'application/json'}).
         to_return(:status => 200, :body => @number_response, :headers => {'Content-Type'=>'application/json'})
      result = @poll.get_phone_number
      puts "Phone: "+result
      
      result.should == '14075551234'
    end

    it "should be assigned a tropo phone number if not already assigned" do
      Poll.stub(:get_phone_number).and_return("14153334444")
      @poll = FactoryGirl.create(:poll, :phone=>"14153334444")
      @poll.phone.should == "14153334444"
    end

    it "should be assigned a passed-in phone number" do
      @poll = FactoryGirl.create(:poll, :phone=>"14151112222")
      @poll.phone.should == "14151112222"
    end

  end


  # Describe a spec test to check that at least one question has been added
  
end
