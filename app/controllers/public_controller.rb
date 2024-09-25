class PublicController < ApplicationController
  def index
    render file: Rails.root.join("public/index.html")
  end

  def privacy_policy
    render file: Rails.root.join("public/privacy_policy.html")
  end
end
