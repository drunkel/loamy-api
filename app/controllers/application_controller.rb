class ApplicationController < ActionController::Base
  skip_forgery_protection
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  respond_to :json

  # before_action :authenticate_user!
end
