module Api
  module V1
    class BikesController < ApiController
      def create
        bikes_params = params.require(:bikes).map do |bike_param|
          bike_param.permit(:gear_id, :name, :last_service_date).merge(user_id: current_user.id)
        end

        bikes = Bike.create!(bikes_params)
        render json: { bikes: bikes }, status: :created
      rescue ActionController::ParameterMissing
        render json: { error: "Bikes parameter is required" }, status: :bad_request
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
