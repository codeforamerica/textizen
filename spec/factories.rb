FactoryGirl.define do
  #   attr_accessible :end_date, :phone, :start_date, :text, :title, :poll_type
  factory :poll do
    start_date { Time.now }
    end_date { Time.now + 1.week }
    
  end
end