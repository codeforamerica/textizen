# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#if not Rails.env.production?

#first create one with a valid tropo phone number for later testing
@polls = []
3.times { @polls << FactoryGirl.create(:poll)}

responses = ['Acme or Supreme', 'I buy groceries in Paris', 'Wal-mart', 'Walgreens', 'CVS', 'Stater bros']

@polls.each do |p|
  53.times { p.responses.create(:from => '1'+rand(10 ** 9).to_s, :to => p.phone, :response => responses.sample) }
end

begin
  FactoryGirl.create(:poll_valid_phone)
rescue
  puts "Valid phone number poll already created #{$!}"
end

# Response.craete()
#   factory :poll do
#     start_date { Time.now }
#     end_date { Time.now + 1.week }
#     phone { '9091234567' }
#     text { 'Where do you buy your groceries?' }
#     title { 'Groceries' }
#     
#     factory :poll_multi do
#       choices {{ "a" => "Wal-mart", "b" => "Bi-rite", "c" => "Bodega"}}
#       poll_type { 'MULTI' }
#     end
#     
#     factory :poll_open do
#       poll_type { 'OPEN' }
#     end
    
#     factory :poll_ended do
#       start_date { Time.now - 1.week }
#       end_date { Time.now - 3.days }
#     end
#   end
# end

