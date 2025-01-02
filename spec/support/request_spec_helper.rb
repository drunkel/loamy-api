module RequestSpecHelper
  def login_user(user)
    post user_session_path,
         params: {
           user: {
             email: user.email,
             password: user.password
           }
         }.to_json,
         headers: json_headers

    @auth_headers = json_headers.merge(
      'Authorization': response.headers['Authorization']
    )
  end

  def json_headers
    {
      'CONTENT_TYPE': 'application/json',
      'ACCEPT': 'application/json'
    }
  end

  def json_response
    JSON.parse(response.body)
  end

  def auth_headers
    @auth_headers || json_headers
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end
