module Strava
  class InitialSyncJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      user = User.find(user_id)
      strava_token = user.strava_tokens.order(created_at: :desc).first

      if strava_token.nil?
        Rails.logger.error("No Strava token found for user #{user_id}")
        return
      end

      access_token = strava_token.access_token
      page = 1
      per_page = 200 # Maximum allowed by Strava API

      loop do
        bike_rides = fetch_bike_rides(access_token, page, per_page)
        break if bike_rides.empty?

        bike_rides.each do |activity|
          save_activity(user, activity)
        end

        page += 1
      end

      # Update the last sync timestamp
      user.update(last_strava_sync_at: Time.current)

      Rails.logger.info("Completed initial sync of bike rides for user #{user_id}")
    end

    private

    def fetch_bike_rides(access_token, page, per_page)
      client = Strava::ApiClient.new(user)
      response = client.get("/athlete/activities", { page: page, per_page: per_page })

      if response.success?
        activities = JSON.parse(response.body)
        activities.select { |activity| activity["type"] == "Ride" }
      else
        Rails.logger.error("Failed to fetch activities: #{response.code} - #{response.body}")
        []
      end
    end

    def save_activity(user, activity_data)
      strava_activity = user.strava_activities.find_or_initialize_by(strava_id: activity_data["id"])

      strava_activity.assign_attributes(
        resource_state: activity_data["resource_state"],
        name: activity_data["name"],
        distance: activity_data["distance"],
        moving_time: activity_data["moving_time"],
        elapsed_time: activity_data["elapsed_time"],
        total_elevation_gain: activity_data["total_elevation_gain"],
        type: activity_data["type"],
        sport_type: activity_data["sport_type"],
        start_date: activity_data["start_date"],
        start_date_local: activity_data["start_date_local"],
        timezone: activity_data["timezone"],
        utc_offset: activity_data["utc_offset"],
        location_city: activity_data["location_city"],
        location_state: activity_data["location_state"],
        location_country: activity_data["location_country"],
        map_id: activity_data.dig("map", "id"),
        map_summary_polyline: activity_data.dig("map", "summary_polyline"),
        gear_id: activity_data["gear_id"],
        external_id: activity_data["external_id"],
        raw_data: activity_data
      )

      if strava_activity.save
        Rails.logger.info("Saved bike ride #{strava_activity.strava_id} for user #{user.id}")
      else
        Rails.logger.error("Failed to save bike ride #{activity_data['id']} for user #{user.id}: #{strava_activity.errors.full_messages}")
      end
    end
  end
end
