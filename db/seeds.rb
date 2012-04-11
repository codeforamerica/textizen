# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
if not Rails.env.production?
  def get_fake_phone
    return '1'+rand(10 ** 9).to_s
  end
  
  #first create one with a valid tropo phone number for later testing
  @polls = []
  4.times { @polls << Poll.create(:start_date => Time.now, :end_date => Time.now + 1.year, :phone => get_fake_phone, :text => 'Where do you buy your groceries?', :title=> 'Groceries', :poll_type=>'OPEN')}
  @polls.each do |p|
    10.times { p.responses.create(:from => get_fake_phone, :to => p.phone, :response => 'I buy groceries IN YOUR FACE') }
    5.times { p.responses.create(:from => get_fake_phone, :to => p.phone, :response => 'I buy groceries in Paris') }
  end
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

