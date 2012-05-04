require 'spec_helper'

describe Question do
  it { should have_many(:responses) }
  it { should belong_to(:poll) }

  it { should validate_presence_of(:poll_id) }
  it { should validate_presence_of(:question_type) }
  it { should allow_value("MULTI").for(:question_type) }
  it { should allow_value("OPEN").for(:question_type) }
  it { should allow_value("YN").for(:question_type) }
  it { should_not allow_value("foo").for(:question_type) }
end
