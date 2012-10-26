FactoryGirl.define do
  
  factory :user do
    email Faker::Internet.email
    password "testpass"
    password_confirmation "testpass"
    role "editor"
  end

  factory :group do
  end

  factory :poll do
    start_date { Time.now - 1.week }
    end_date { Time.now + 1.week }
    phone {'1'+rand(10 ** 10).to_s}
    title 'Groceries'
    #user
    
    factory :poll_multi do
      after(:create) do |poll, evaluator|
        FactoryGirl.create(:question_multi,  poll: poll)
      end
    end
    
    factory :poll_open do
      after(:create) do |poll, evaluator|
        FactoryGirl.create(:question,  poll: poll)
      end
    end

    factory :poll_yn do
      after(:create) do |poll, evaluator|
        FactoryGirl.create(:question_yn,  poll: poll)
      end
    end

    factory :poll_with_question do
      after(:create) do |poll, evaluator|
        FactoryGirl.create(:question,  poll: poll)
      end
    end

    factory :poll_ended do
      start_date { Time.now - 1.week }
      end_date { Time.now - 3.days }
    end

    factory :poll_valid_phone do
      phone '14842020381'
      title 'New SEPTA Stop'
    end

    factory :poll_with_responses do
      questions {|questions| [questions.association(:question_with_responses)]}
    end
  end

  factory :question do
    text "Where do you buy groceries?"
    question_type 'OPEN'
    poll

    # factory for question with responses, pass in response_count to create more responses
    factory :question_with_responses do
      ignore do
        response_count 1
      end
      after(:create) do |question, evaluator|
        FactoryGirl.create_list(:response, evaluator.response_count, question: question)
      end
    end
    
    factory :question_multi do
      question_type 'MULTI'
#      options '{ "a":{"val":"Wal-mart"}, "b":{"val":"Bi-rite"}, "c":{"val":"Bodega"} }'
      after(:create) do |question, evaluator|
        FactoryGirl.create(:option, value: 'a', text: 'wal-mart', question: question) 
        FactoryGirl.create(:option, value: 'b', text: 'farmers market', question: question) 
        FactoryGirl.create(:option, value: 'c', text: 'corner store', question: question) 
      end
    end

    factory :question_with_follow_up do
      question_type 'YN'
      text "Would you ride light rail along the boulevard?"
      after(:create) do |question, evaluator|
        @y = FactoryGirl.create(:option_y, question: question) 
        @fup = FactoryGirl.create(:question)
        @y.follow_up = @fup
        @y.save
        FactoryGirl.create(:option_n, question: question) 
      end
    end

    factory :question_yn do
      question_type 'YN'
      text "Would you ride light rail along the boulevard?"
      after(:create) do |question, evaluator|
        FactoryGirl.create(:option_y, question: question) 
        FactoryGirl.create(:option_n, question: question) 
      end
    end
  end

  factory :response do
    from {'1'+rand(10 ** 10).to_s}
    response 'I buy groceries IN YOUR FACE'
    question
    
    factory :response_y do
      response 'y'
    end
    factory :response_n do
      response 'n'
    end
  end

  factory :option do
    question
    text 'wal-mart'
    value 'a'

    factory :option_y do
      text 'yes'
      value 'y'
    end

    factory :option_n do
      text 'no'
      value 'n'
    end
  end
end
