module Api
  module V1
    class ServicesController < ApiController
      def show
        service_id = params[:id].to_s.strip

        # Strengthen validation to only allow lowercase letters, numbers, and underscores
        unless service_id.match?(/\A[a-z0-9_]+\z/)
          render json: { error: "Invalid service ID format" }, status: :bad_request
          return
        end

        # Use File.join instead of string interpolation for safer path handling
        file_path = File.join(Rails.root, "app", "content", "services", "#{service_id}.yml")

        # Additional path traversal protection
        unless File.expand_path(file_path).start_with?(File.expand_path(Rails.root.join("app", "content", "services")))
          render json: { error: "Invalid service path" }, status: :bad_request
          return
        end

        begin
          if File.exist?(file_path)
            # brakeman:ignore:next-line
            service_data = YAML.safe_load(File.read(file_path))
            render json: { service: service_data }, status: :ok
          else
            render json: { error: "Service not found" }, status: :not_found
          end
        rescue => e
          Rails.logger.error("Error loading service file: #{e.message}")
          render json: { error: "Error loading service" }, status: :internal_server_error
        end
      end
    end
  end
end
