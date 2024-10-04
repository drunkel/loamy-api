class StravaToken < ApplicationRecord
  belongs_to :user

  validates :token_type, :expires_at, :expires_in, :refresh_token, :access_token, :athlete_id, presence: true
end
