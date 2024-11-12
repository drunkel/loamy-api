class Api::ApiController < ApplicationController
  before_action :authenticate_user!

  private

  respond_to :json
end
