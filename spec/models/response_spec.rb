require 'spec_helper'

describe Response do
  it { should belong_to(:poll) }
  it { should validate_presence_of(:to) }
  it { should validate_presence_of(:from) } 
  it { should validate_presence_of(:response) } 
end
