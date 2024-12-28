module Api
  module V1
    class ServiceIntervalsController < ApiController
      def index
        bike = current_user.bikes.find_by!(gear_id: params[:bike_id])
        service_intervals = bike.service_intervals.includes(:service_logs)

        render json: service_intervals.map { |interval| ::ServiceIntervalSerializer.new(interval).as_json }
      end
    end
  end
end
