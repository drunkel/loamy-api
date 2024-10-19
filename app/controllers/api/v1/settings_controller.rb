module Api
  module V1
    class SettingsController < ApplicationController
      before_action :authenticate_user!

      def update
        if current_user.update(user_params)
          render json: { message: "Settings updated successfully", user: current_user }, status: :ok
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:setting).permit(:last_service_date)
      end
    end
  end
end
