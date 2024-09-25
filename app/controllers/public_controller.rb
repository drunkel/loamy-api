class PublicController < ApplicationController
  def index
    render "index", layout: false
  end

  def privacy_policy
    render file: Rails.root.join("public/privacy_policy.html")
  end
end
