module Api
  module V1
    class RideStatsController < ApiController
      def index
        start_date = 1.month.ago.beginning_of_day
        end_date = Time.current.end_of_day
        activities = current_user.strava_activities
                                 .where(type: "Ride")
                                 .where(start_date: start_date..end_date)

        stats = {
          num_rides: activities.count,
          distance: activities.sum(:distance).round(2),
          elevation: activities.sum(:total_elevation_gain).round(2),
          time: activities.sum(:moving_time)
        }

        render json: stats, status: :ok
      end
    end
  end
end
