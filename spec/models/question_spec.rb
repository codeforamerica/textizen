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
  
  describe '#valid_response?' do
    before(:each) do
      @question = FactoryGirl.create(:question_yn)
    end
    context 'valid y response' do
      it 'should return true for #valid_response?' do
        @question.valid_response?('y').should == true
      end
    end

    context 'valid YES response' do
      it 'should return true for #valid_response?' do
        @question.valid_response?('YES').should == true
      end

    end
    context 'invalid POTATOE response' do
      it 'should return true for #valid_response?' do
        @question.valid_response?('POTATOE').should == false
      end
    end
  end
  describe 'followup functions' do
    context "has no followup" do
      it 'should return false for get_follow_up' do
        question = FactoryGirl.create(:question)
        question.get_follow_up.should == false
      end
      it 'should return false for send_follow_up?' do
        question = FactoryGirl.create(:question)
        question.send_follow_up?('y').should == false
      end
    end

    # create question with followup
    context "option has a followup question" do
      it 'should return a follow_up for get_follow_up' do
        question = FactoryGirl.create(:question)
        follow_up = FactoryGirl.create(:question)
        option = FactoryGirl.create(:option, :question => question, :follow_up => follow_up)

        question.get_follow_up.should eq(follow_up)
      end

      context "response matches followup value" do
        it 'should return true for #get_follow_up' do
          question = FactoryGirl.create(:question)
          follow_up = FactoryGirl.create(:question)
          option = FactoryGirl.create(:option_y, :question => question, :follow_up => follow_up)
          question.send_follow_up?('y').should == true
        end
      end

      context "response does not match followup value" do
        it 'should return false for #get_follow_up' do
          question = FactoryGirl.create(:question)
          follow_up = FactoryGirl.create(:question)
          option = FactoryGirl.create(:option_y, :question => question, :follow_up => follow_up)
          question.send_follow_up?('n').should == false
          
        end
      end
    end

    it 'should return false for follow_up_triggered when no follow-up triggered' do
      question = FactoryGirl.create(:question)
      follow_up = FactoryGirl.create(:question)
      option = FactoryGirl.create(:option_y, question: question, follow_up: follow_up)
      question.responses.create(from: '12223334444', response: 'n')
      question.follow_up_triggered?('12223334444').should eq false
    end

    # create question with answered follow_up
    it 'should return true for follow_up_triggered' do
      question = FactoryGirl.create(:question)
      follow_up = FactoryGirl.create(:question)
      option = FactoryGirl.create(:option_y, question: question, follow_up: follow_up)
      question.responses.create(from: '12223334444', response: 'y')
      question.follow_up_triggered?('12223334444').should eq true
    end
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
