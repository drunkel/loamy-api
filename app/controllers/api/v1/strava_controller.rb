module Api
  module V1
    class StravaController < ApiController
      def index
        render json: { message: "Hello from Strava" }, status: :ok
      end

      def create
        response = exchange_token(params[:code])

        if response.success?
          puts "response.parsed_response: #{response.parsed_response}"
          render json: response.parsed_response, status: :ok
        else
          puts "ERROR GETTING TOKEN"
          render json: { error: "Failed to exchange code for tokens" }, status: :bad_request
        end
      end

      private

      def exchange_token(code)
        HTTParty.post("https://www.strava.com/oauth/token", {
          body: {
            client_id: ENV["STRAVA_CLIENT_ID"],
            client_secret: ENV["STRAVA_CLIENT_SECRET"],
            code: code,
            grant_type: "authorization_code"
          }
        })
      end
    end
  end
end
