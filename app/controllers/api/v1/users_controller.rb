class Api::V1::UsersController < Api::ApiController
  skip_before_action :authenticate_user!, only: [ :create ]

  def create
    @user = User.new(user_params)
    if @user.save
      token = JWT.encode(
        { user_id: @user.id, exp: 24.hours.from_now.to_i },
        ENV["DEVISE_JWT_SECRET_KEY"],
        "HS256"
      )
      puts "token: #{token}"
      render json: { message: "User created successfully", token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
