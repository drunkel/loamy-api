class User < ApplicationRecord
  devise :database_authenticatable,
          :jwt_authenticatable, :registerable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :strava_tokens
  has_many :strava_activities
  has_many :tasks

  # You can add a scope to easily find users who need syncing
  scope :needs_strava_sync, -> { where(last_strava_sync_at: nil).or(where("last_strava_sync_at < ?", 1.day.ago)) }
end
