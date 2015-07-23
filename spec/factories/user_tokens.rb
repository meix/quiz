# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_token do
    id 1
    user_id 1
    token "string"
  end
end
