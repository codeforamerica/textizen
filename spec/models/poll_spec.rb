require 'spec_helper'

describe Poll do

  
  it { should have_many(:responses) }
  it { should belong_to(:user) }
  
  it { should allow_value("MULTI").for(:poll_type) }
  it { should allow_value("OPEN").for(:poll_type) }
  it { should_not allow_value("foo").for(:poll_type) }


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
         to_return(:status => 200, :body => '', :headers => {})
      stub_request(:post, "https://api.tropo.com/v1/applications//addresses").
         with(:body => "{\"type\":\"number\",\"prefix\":\"1415\"}",
              :headers => {'Content-Type'=>'application/json'}).
         to_return(:status => 200, :body => @number_response, :headers => {'Content-Type'=>'application/json'})
      result = @poll.get_phone_number
      result.should == '1407'
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
end
