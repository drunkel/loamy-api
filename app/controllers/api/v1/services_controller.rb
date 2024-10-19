module Api
  module V1
    class ServicesController < ApplicationController
      before_action :authenticate_user!
      def show
        service_id = params[:id]
        file_path = Rails.root.join("app", "content", "services", "#{service_id}.yml")

        if File.exist?(file_path)
          @service = YAML.load_file(file_path)
          render json: @service, status: :ok
        else
          render json: { error: "Service not found" }, status: :not_found
        end
      end
    end
  end
end
