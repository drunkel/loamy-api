FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'password123' }
    # Add any other required attributes for your User model
  end
end
