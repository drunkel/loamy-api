module Strava
  class ApiClient
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def get(path, query = {})
      make_request(:get, path, query: query)
    end

    def post(path, body = {})
      make_request(:post, path, body: body)
    end

    private

    def make_request(method, path, options = {})
      token = user.strava_tokens.last
      return failed_response("No Strava token found") if token.nil?

      response = HTTParty.send(
        method,
        "https://www.strava.com/api/v3#{path}",
        options.merge(
          headers: { "Authorization" => "Bearer #{token.access_token}" }
        )
      )

      if response.code == 401 && token.expires_at < Time.current.to_i
        token = refresh_token(token)
        return failed_response("Failed to refresh token") if token.nil?

        # Retry the request with the new token
        response = HTTParty.send(
          method,
          "https://www.strava.com/api/v3#{path}",
          options.merge(
            headers: { "Authorization" => "Bearer #{token.access_token}" }
          )
        )
      end

      response
    end

    def refresh_token(token)
      response = HTTParty.post(
        "https://www.strava.com/oauth/token",
        body: {
          client_id: ENV["STRAVA_CLIENT_ID"],
          client_secret: ENV["STRAVA_CLIENT_SECRET"],
          refresh_token: token.refresh_token,
          grant_type: "refresh_token"
        }
      )

      return nil unless response.success?

      token_data = response.parsed_response
      token.update(
        access_token: token_data["access_token"],
        refresh_token: token_data["refresh_token"],
        expires_at: token_data["expires_at"],
        expires_in: token_data["expires_in"]
      )
      token
    end

    def failed_response(message)
      OpenStruct.new(
        success?: false,
        code: 401,
        message: message
      )
    end
  end
end
