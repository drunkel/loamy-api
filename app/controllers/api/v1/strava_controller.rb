module Api
  module V1
    class StravaController < ApiController
      def index
        render json: { message: "Hello from Strava" }, status: :ok
      end

      def create
        response = exchange_token(params[:code])

        if response.success?
          token_data = response.parsed_response

          current_user.strava_tokens.create!(
            token_type: token_data["token_type"],
            expires_at: token_data["expires_at"],
            expires_in: token_data["expires_in"],
            refresh_token: token_data["refresh_token"],
            access_token: token_data["access_token"],
            athlete_id: token_data["athlete"]["id"],
            athlete_username: token_data["athlete"]["username"]
          )

          Strava::InitialSyncJob.perform_later(current_user.id)

          render json: { message: "Strava token saved successfully and sync initiated" }, status: :ok
        else
          render json: { error: "Failed to exchange code for tokens" }, status: :bad_request
        end
      end

      def fetch_bikes
        client = Strava::ApiClient.new(current_user)
        response = client.get("/athlete")

        puts("response: #{response.parsed_response}")

        if response.success?
          bikes = response.parsed_response["bikes"] || []
          puts("returning bikes: #{bikes}")
          render json: { bikes: bikes }, status: :ok
        else
          Rails.logger.error("Error fetching bikes: #{response.code} - #{response.message}")
          render json: { error: "Error fetching bikes" }, status: :internal_server_error
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
