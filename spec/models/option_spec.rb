require 'spec_helper'

describe Option do
  it { should belong_to(:question) }
  it { should have_many(:follow_up) }
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:value) }
  
  describe "#match?" do
    before do
      @o = FactoryGirl.build_stubbed(:option)
    end

    it "returns true if the value passed matched the first letter of the option value" do
      @o.match?('a').should eq(true)
    end

    it "returns true if the value passed matches the option text" do
      @o.match?('wal-mart').should eq(true)
    end

    it "returns false if nothing matches" do
      @o.match?('target').should eq(false)
    end
  end
end
