class RemoveUniqueConstraintFromStravaActivities < ActiveRecord::Migration[7.2]
  def change
    remove_index :strava_activities, :strava_id
    add_index :strava_activities, :strava_id
  end
end
