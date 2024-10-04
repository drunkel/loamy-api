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
      all_activities = []

      loop do
        activities = fetch_activities(access_token, page, per_page)
        break if activities.empty?

        bike_rides = activities.select { |activity| activity["type"] == "Ride" }
        all_activities.concat(bike_rides)

        page += 1
      end

      puts "Found #{all_activities.length} bike rides for user #{user_id}"
      all_activities.each do |activity|
        puts "Activity: #{activity['name']} - Date: #{activity['start_date']} - Distance: #{activity['distance']} meters"
      end
    end

    private

    def fetch_activities(access_token, page, per_page)
      url = "https://www.strava.com/api/v3/athlete/activities"
      response = HTTParty.get(url,
        headers: { "Authorization" => "Bearer #{access_token}" },
        query: { page: page, per_page: per_page }
      )

      if response.success?
        JSON.parse(response.body)
      else
        Rails.logger.error("Failed to fetch activities: #{response.code} - #{response.body}")
        []
      end
    end
  end
end
