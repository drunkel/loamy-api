# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
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
        message: "Account creation failed",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
