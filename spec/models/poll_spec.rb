require 'spec_helper'

describe Poll do
  it { should have_many(:responses) }
  it { should belong_to(:user) }
  it { should allow_value("MULTI").for(:poll_type) }
  it { should allow_value("OPEN").for(:poll_type) }
  it { should_not allow_value("foo").for(:poll_type) }
  
  
  
  it { should validate_uniqueness_of(:phone) }
end
