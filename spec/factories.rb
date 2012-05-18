FactoryGirl.define do
  
  factory :poll do
    start_date { Time.now - 1.week }
    end_date { Time.now + 1.week }
    phone {'1'+rand(10 ** 10).to_s}
    title 'Groceries'
    #user
    
    factory :poll_multi do
    end
    
    factory :poll_open do
    end

    factory :poll_yn do
      after_create do |poll, evaluator|
        FactoryGirl.create(:question_yn,  poll: poll)
      end
    end

    factory :poll_with_question do
      after_create do |poll, evaluator|
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

    factory :question_with_responses do

    end

    factory :question_multi do
      question_type 'MULTI'
#      options '{ "a":{"val":"Wal-mart"}, "b":{"val":"Bi-rite"}, "c":{"val":"Bodega"} }'
    end

    factory :question_yn do
      question_type 'YN'
      text "Would you ride light rail along the boulevard?"
      after_create do |question, evaluator|
        FactoryGirl.create(:option_y, question: question) 
        FactoryGirl.create(:option_n, question: question) 
      end
    end
  end

  factory :response do
    from {'1'+rand(10 ** 10).to_s}
    response 'I buy groceries IN YOUR FACE'
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
