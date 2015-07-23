# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_option do
    id 1
    question_id 1
    description "正确选项"
    ordinal "A"
  end
end
