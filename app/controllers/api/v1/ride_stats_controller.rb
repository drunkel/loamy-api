module Api
  module V1
    class RideStatsController < ApiController
      def index
        start_date = 1.month.ago.beginning_of_day
        end_date = Time.current.end_of_day

        if params[:range] == "this_year"
          start_date = 1.year.ago.beginning_of_day
          end_date = Time.current.end_of_day
        end

        if params[:range] == "last_7_days"
          start_date = 7.days.ago.beginning_of_day
          end_date = Time.current.end_of_day
        end

        if params[:range] == "last_30_days"
          start_date = 30.days.ago.beginning_of_day
          end_date = Time.current.end_of_day
        end

        activities = current_user.strava_activities
                                 .where(type: "Ride")
                                 .where(start_date: start_date..end_date)

        stats = {
          num_rides: activities.count,
          distance: activities.sum(:distance).round(2),
          elevation: activities.sum(:total_elevation_gain).round(2),
          time: activities.sum(:moving_time)
        }

        render json: { stats: stats, last_strava_sync_at: current_user.last_strava_sync_at }, status: :ok
      end
    end
  end
end
