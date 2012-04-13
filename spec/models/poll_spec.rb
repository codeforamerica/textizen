require 'spec_helper'

describe Poll do

  
  it { should have_many(:responses) }
  it { should belong_to(:user) }
  
  it { should allow_value("MULTI").for(:poll_type) }
  it { should allow_value("OPEN").for(:poll_type) }
  it { should_not allow_value("foo").for(:poll_type) }

  describe "check phone assignment and uniqueness" do

    before(:each) do
      FactoryGirl.create(:poll)
    end
    
    it { should validate_uniqueness_of(:phone) }
    
    it "should be assigned a tropo phone number if not already assigned" do
      Poll.stub(:get_phone_number).and_return("+14153334444")
      @poll = Poll.create(:poll_type=>'OPEN')
      @poll.phone.should == "+14153334444"
    end

    it "should be assigned a passed-in phone number" do
      @poll = Poll.create(:poll_type=>'OPEN', :phone=>"+14151112222")
      @poll.phone.should == "+14151112222"
    end

  end
end
