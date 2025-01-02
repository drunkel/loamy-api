FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password123' }
    # Add any other required attributes for your User model
  end
end
