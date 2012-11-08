require 'spec_helper'

describe User do
  let(:user){ FactoryGirl.create(:user) }

  it { should have_many(:created_polls) }
  it { should have_many(:group_users) }
  it { should have_many(:groups) }
  it { should have_many(:polls) }
  
  it { should validate_uniqueness_of(:email) }

  describe "#role?" do
    it "returns true if argument matches user role" do
      user.role?(:editor).should be_true
    end

    it "returns false if argument does not match user role" do
      user.role?(:superadmin).should be_false
    end

    it "returns false if user has no role" do
      user.role = nil
      user.role?(:editor).should be_false
    end
  end

  describe "#visible_polls" do
    let(:poll){ FactoryGirl.create(:poll) }

    context "superadmin" do
      it "returns all polls existing" do
        poll.touch
        user.role = "superadmin"
        user.visible_polls.should include(poll)
      end
    end

    context "user with polls" do
      it "returns that users polls" do
        group = poll.groups.create
        group.users << user
        group.save
        user.visible_polls.should include(poll)
      end
    end

    context "user with no polls" do
      it "returns an empty array" do
        user.visible_polls.should == []
      end
    end
  end
end
