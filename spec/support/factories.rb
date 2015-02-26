require 'factory_girl_rails'

FactoryGirl.define do
  factory :user do
    sequence(:name)     { |n| "User #{n}" }
    sequence(:email)    { |n| "email#{n}@curupira.com" }
    sequence(:username) { |n| "user_#{n}" }
    password 12345678
    active true
  end

  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    active true
  end

  factory :group_user do
    group
    user
  end
end
