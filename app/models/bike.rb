class Bike < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :gear_id, uniqueness: { scope: :user_id }, allow_nil: true
end
