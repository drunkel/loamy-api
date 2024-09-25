class PublicController < ApplicationController
  def index
    render :index, layout: false
  end

  def privacy_policy
    render file: Rails.root.join("public/privacy_policy.html")
  end

  def waitlist
    if params[:email].present?
      WaitlistMailer.new_signup(params[:email]).deliver_now

      flash.now[:success] = "Thanks! We'll be in touch soon."
      render json: { status: "success", message: flash.now[:success] }
    else
      flash.now[:error] = "Please provide a valid email address."
      render json: { status: "error", message: flash.now[:error] }, status: :unprocessable_entity
    end
  end
end
