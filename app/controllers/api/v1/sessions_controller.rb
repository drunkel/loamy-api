module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :authenticate_user!, only: [ :create ]
      respond_to :json

      def create
        user = User.find_by_email(sign_in_params[:email])

        if user && user.valid_password?(sign_in_params[:password])

          token = JWT.encode(
            { user_id: user.id, exp: 24.hours.from_now.to_i },
            ENV["DEVISE_JWT_SECRET_KEY"],
            "HS256"
          )
          render json: { token: token }, status: :created
        else
          render json: { message: "Invalid email or password." }, status: :unauthorized
        end
      end

      def destroy
        sign_out(current_user)
        render json: { message: "Signed out successfully." }, status: :ok
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end
