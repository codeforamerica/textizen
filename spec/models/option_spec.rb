require 'spec_helper'

describe Option do
  it { should belong_to(:question) }
  it { should have_one(:question) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:value) }
end
