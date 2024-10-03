class Api::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :print_headers
  before_action :authenticate_user!

  private

  def print_headers
    puts "Request Headers:"
    request.headers.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  respond_to :json
end
