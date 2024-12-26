# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  private

  # Customize the response for a successful sign-up
  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: "Account created successfully",
        user: resource
      }, status: :created
    else
      render json: {
        message: "Account creation failed. Check your email and password.",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
