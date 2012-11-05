require 'spec_helper'

describe Question do

  let(:question){ FactoryGirl.create(:question) }

  it { should have_many(:responses) }
  it { should have_many(:options) }
  it { should have_many(:follow_up) }
  it { should have_many(:follow_up_options) }
  it { should have_many(:follow_up_responses) }

  it { should belong_to(:poll) }
  it { should belong_to(:option) }


  it { should allow_value("MULTI").for(:question_type) }
  it { should allow_value("OPEN").for(:question_type) }
  it { should allow_value("YN").for(:question_type) }
  it { should_not allow_value("foo").for(:question_type) }

  it { should validate_presence_of(:question_type) }
  it { should validate_presence_of(:text) }

  describe '#valid_response?' do
    context "Yes/No question" do
      let(:question){ FactoryGirl.create(:question_yn) }

      it 'returns true if response is abbreviation of Yes' do
        question.valid_response?('y').should == true
      end

      it 'returns true if response is uppercase' do
        question.valid_response?('YES').should == true
      end

      it 'returns false if response is not variation on Yes or No' do
        question.valid_response?('POTATOE').should == false
      end
    end

    context "multiple choice question" do
      let(:question){ FactoryGirl.create(:question_multi) }

      it "returns true if response is amongst options" do
        question.valid_response?('a').should == true
      end

      it "returns false if response is not amongst options" do
        question.valid_response?('wheeee!!!').should == false
      end
    end

    context "open question" do
      it "always returns true" do
        question.valid_response?("zippity doo dah").should == true
      end
    end
  end

  describe 'followup functions' do
    context "has no followup" do
      describe "#get_follow_up" do
        it 'returns false' do
          question.get_follow_up.should == false
        end
      end

      describe "#send_follow_up?" do
        it 'return false' do
          question.send_follow_up?('y').should == false
        end
      end
    end

    # create question with followup
    context "option has a followup question" do
      before :each do
        option = FactoryGirl.create(:option_y, :question => question)
        @follow_up = option.follow_up.create(:text => "YOU SUCK, yes?", :question_type => "OPEN")
      end

      describe "#get_follow_up" do
        it 'returns a follow_up object' do
          question.get_follow_up.should eq(@follow_up)
        end
      end

      describe "#send_follow_up?" do 
        it 'returns true for #send_follow_up? if response matches followup value' do
          question.send_follow_up?('y').should == true
        end

        it 'returns false for #send_follow_up? if response does not match followup value' do
          question.send_follow_up?('n').should == false
        end
      end

      describe "#follow_up_triggered?" do
        it 'returns false when no follow-up triggered' do
          question.responses.create(from: '12223334444', response: 'n')
          question.follow_up_triggered?('12223334444').should eq false
        end

        it 'returns true when a follow up has been sent' do
          question.responses.create(from: '12223334444', response: 'y')
          question.follow_up_triggered?('12223334444').should eq true
        end
      end
    end
  end

  describe 'question type helper booleans' do
    describe "#yn?" do
      it 'returns true if a YN poll was created' do
        q = FactoryGirl.create(:question_yn)
        q.yn?.should == true
      end
    end

    describe "#multi?" do
      it 'returns true if a MULTI poll was created' do
        q = FactoryGirl.create(:question_multi)
        q.multi?.should == true
      end
    end

    describe "#open?" do
      it 'returns true if a OPEN poll was created' do
        q = FactoryGirl.create(:question)
        q.open?.should == true
      end
    end
  end

  describe '#answered?' do
    let(:from){ '15553331234' }

    it 'returns true if question was answered by this person' do
      question.responses.create(from: from, response: 'hello')
      question.answered?(from).should == true
    end
    it 'returns false if question was not answered by this person' do
      question.answered?(from).should == false 
    end
  end

  describe "#to_sms" do
    pending
  end

  describe "#response_histogram" do
    pending
  end
end
