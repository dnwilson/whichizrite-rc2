# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_preference do
    preference nil
    user nil
  end
end
