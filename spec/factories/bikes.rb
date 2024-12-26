FactoryBot.define do
  factory :bike do
    user
    sequence(:name) { |n| "Bike #{n}" }
    sequence(:gear_id) { |n| "b#{n}" }
    last_service_date { Date.current }
  end
end
