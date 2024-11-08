class StravaActivity < ApplicationRecord
  belongs_to :user

  validates :strava_id, presence: true

  # Disable STI
  self.inheritance_column = :_type_disabled
end
