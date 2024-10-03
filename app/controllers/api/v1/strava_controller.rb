module Api
  module V1
    class StravaController < ApiController
      def create
        response = exchange_token(params[:code])

        if response.success?
          render json: response.parsed_response, status: :ok
        else
          render json: { error: "Failed to exchange code for tokens" }, status: :bad_request
        end
      end

      private

      def exchange_token(code)
        HTTParty.post("https://www.strava.com/oauth/token", {
          body: {
            client_id: Rails.application.credentials.strava[:client_id],
            client_secret: Rails.application.credentials.strava[:client_secret],
            code: code,
            grant_type: "authorization_code"
          }
        })
      end
    end
  end
end
