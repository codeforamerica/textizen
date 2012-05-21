require 'spec_helper'

describe Question do
  it { should have_many(:responses) }
  it { should belong_to(:poll) }
  it { should belong_to(:option) }


  it { should allow_value("MULTI").for(:question_type) }
  it { should allow_value("OPEN").for(:question_type) }
  it { should allow_value("YN").for(:question_type) }
  it { should_not allow_value("foo").for(:question_type) }

  describe 'check validations' do
    it { should validate_presence_of(:poll_id) }
    it { should validate_presence_of(:question_type) }
  end 
  
  describe 'check followup functions' do


  end

  describe 'check question type helper booleans' do
    it 'should return true for YN if a YN poll was created' do
      @q = FactoryGirl.create(:question_yn)
      @q.yn?.should == true
    end
    it 'should return true for MULTI if a MULTI poll was created' do
      @q = FactoryGirl.create(:question_multi)
      @q.multi?.should == true
    end
    it 'should return true for OPEN if a OPEN poll was created' do
      @q = FactoryGirl.create(:question)
      @q.open?.should == true
    end
  end
end
