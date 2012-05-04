# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :option do
    text "MyString"
    question_id 1
    value "MyString"
    follow_up_id 1
  end
end
