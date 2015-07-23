# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :train_log do
    id 1
    user_id 1
    question_id 1
    total_times 1
    right_times 1
    diamond 5
  end
end
