# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    id 1
    nick_name "二货程序员"
    email "123456789@qq.com"
    age 22
    sex 1
    avatar "http://www.abidu.com"
  end
end
