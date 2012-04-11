FactoryGirl.define do
  #   attr_accessible :end_date, :phone, :start_date, :text, :title, :poll_type
  factory :poll do
    start_date { Time.now }
    end_date { Time.now + 1.week }
    phone { '9091234567' }
    text { 'Where do you buy your groceries?' }
    title { 'Groceries' }
    
    factory :poll_multi do
      choices {{ "a" => "Wal-mart", "b" => "Bi-rite", "c" => "Bodega"}}
      poll_type { 'MULTI' }
    end
    
    factory :poll_open do
      poll_type { 'OPEN' }
    end
    
    factory :poll_ended do
      start_date { Time.now - 1.week }
      end_date { Time.now - 3.days }
    end
  end
end