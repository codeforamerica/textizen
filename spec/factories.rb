FactoryGirl.define do
  
  factory :poll do
    start_date { Time.now }
    end_date { Time.now + 1.week }
    phone {'1'+rand(10 ** 10).to_s}
    text 'Where do you buy your groceries?'
    title 'Groceries'
    poll_type 'OPEN'
    
    factory :poll_multi do
      choices {{ "a" => "Wal-mart", "b" => "Bi-rite", "c" => "Bodega"}}
      poll_type 'MULTI'
    end
    
    factory :poll_open do
      poll_type 'OPEN' 
    end
    
    factory :poll_ended do
      start_date { Time.now - 1.week }
      end_date { Time.now - 3.days }
    end

    factory :poll_valid_phone do
      phone '14842020381'
      title 'New SEPTA Stop'
      text 'Where should the new SEPTA stop go?'
    end
  end

  factory :response do
    from {'1'+rand(10 ** 10).to_s}
    response 'I buy groceries IN YOUR FACE'
    poll
  end


end