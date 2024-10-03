class Api::ApiController < ApplicationController
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
