module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      def create
        user = User.find_by_email(sign_in_params[:email])

        if user && user.valid_password?(sign_in_params[:password])
          @current_user = user
          render json: {
            message: "Signed in successfully.",
            user: user.as_json(only: [ :id, :email ])
          }, status: :ok
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
