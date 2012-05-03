FactoryGirl.define do
  
  factory :poll do
    start_date { Time.now - 1.week }
    end_date { Time.now + 1.week }
    phone {'1'+rand(10 ** 10).to_s}
    title 'Groceries'
    
    factory :poll_multi do
    end
    
    factory :poll_open do
    end
    
    factory :poll_ended do
      start_date { Time.now - 1.week }
      end_date { Time.now - 3.days }
    end

    factory :poll_valid_phone do
      phone '14842020381'
      title 'New SEPTA Stop'
    end
  end

  factory :question do
    text "Where do you buy groceries?"
    next_question_id 1
    poll_id 1
    options "MyText"
    question_type "MyString"
  end

  factory :response do
    from {'1'+rand(10 ** 10).to_s}
    response 'I buy groceries IN YOUR FACE'
    poll
  end


end
