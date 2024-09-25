# using SendGrid's Ruby Library
# https://github.com/sendgrid/sendgrid-ruby
require "sendgrid-ruby"
include SendGrid
class PublicController < ApplicationController
  def index
    render :index, layout: false
  end

  def privacy_policy
    render file: Rails.root.join("public/privacy_policy.html")
  end

  def waitlist
    if params[:email].present?
      from = SendGrid::Email.new(email: "getloamyapp@gmail.com")
      to = SendGrid::Email.new(email: "dylan.runkel@gmail.com")
      subject = "Loamy: New Waitlist Signup"
      content = SendGrid::Content.new(type: "text/plain", value: "New waitlist signup: #{params[:email]}")
      mail = SendGrid::Mail.new(from, subject, to, content)

      sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
      response = sg.client.mail._("send").post(request_body: mail.to_json)

      if response.status_code.to_i == 202
        flash.now[:success] = "Thanks! We'll be in touch soon."
        render json: { status: "success", message: flash.now[:success] }
      else
        flash.now[:error] = "There was an error processing your request. Please try again later."
        render json: { status: "error", message: flash.now[:error] }, status: :unprocessable_entity
      end
    else
      flash.now[:error] = "Please provide a valid email address."
      render json: { status: "error", message: flash.now[:error] }, status: :unprocessable_entity
    end
  end
end
