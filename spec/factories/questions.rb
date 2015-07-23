# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    id 1
    title "我是一个测试题目"
    answer "A"
    category "营养"
    level 1
    explain "我是题目解释"
    status 0
    quiz_type 0
  end
end
