require 'spec_helper'

describe Group do
  let(:group){ FactoryGirl.create(:group) }

  it { should have_and_belong_to_many(:polls) }
  it { should have_many (:group_users) }
  it { should have_many (:users) }

  describe "#update_polls" do
    pending
  end

  describe "#save_users_by_emails" do
    context "user exists" do
      it "adds the user to the group" do
        user = FactoryGirl.create(:user)
        group.users.length.should == 0
        group.save_users_by_emails([user.email])
        group.users.length.should == 1
        group.users.should include(user)
      end
    end

    context "new user" do
      it "adds the user to the group" do
        group.users.length.should == 0
        group.save_users_by_emails(["testing@faker.com"])
        group.users.length.should == 1
        group.users.first.email.should == "testing@faker.com"
      end
    end
  end

  describe "#get_exchanges" do
    before :each do
      stub_request(:get, "https://api.tropo.com/v1/exchanges").to_return(:body => fixture("exchanges.json"))
    end

    it "returns a hash of prefixes and prefix information" do
      exchanges = group.get_exchanges
      exchanges.length.should == 3
      exchanges["1747"].should_not be_nil
    end
  end
end
