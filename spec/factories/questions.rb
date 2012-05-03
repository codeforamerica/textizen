# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    text "MyString"
    next_question_id 1
    poll_id 1
    options "MyText"
    question_type "MyString"
  end
end
