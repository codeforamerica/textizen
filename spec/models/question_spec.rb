require 'spec_helper'

describe Question do
  it { should have_many(:responses) }
  it { should belong_to(:poll) }
  it { should belong_to(:option) }

  it { should validate_presence_of(:poll_id) }
  it { should validate_presence_of(:question_type) }

  it { should allow_value("MULTI").for(:question_type) }
  it { should allow_value("OPEN").for(:question_type) }
  it { should allow_value("YN").for(:question_type) }
  it { should_not allow_value("foo").for(:question_type) }

  describe 'check question type helper booleans' do
    before(:each) do
      @poll = FactoryGirl.create(:poll)
    end

   it 'should return true for YN if a YN poll was created' do
     @poll.questions.create(FactoryGirl.build(:question_yn))
     @poll_yn.questions.first.yn?.should_equal true
   end
   it 'should return true for MULTI if a MULTI poll was created' do
     @poll.questions.create(FactoryGirl.build(:question_multi))
     @poll_multi.questions.first.multi?.should_equal true
   end
   it 'should return true for OPEN if a OPEN poll was created' do
     @poll.questions.create(FactoryGirl.build(:question))
     @poll_open.questions.first.open?.should_equal true
   end
  end
end
