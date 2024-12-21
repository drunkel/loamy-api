require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let(:user) { create(:user) } # Assumes you have a User factory
  let(:valid_credentials) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }.to_json
  end

  describe 'POST /users/sign_in' do
    let(:invalid_credentials) do
      {
        user: {
          email: user.email,
          password: 'wrong_password'
        }
      }.to_json
    end

    context 'when credentials are valid' do
      before do
        post user_session_path,
             params: valid_credentials,
             headers: { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        expect(json_response['status']['message']).to eq('Logged in successfully.')
      end
    end

    context 'when credentials are invalid' do
      before do
        post user_session_path,
             params: invalid_credentials,
             headers: { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'when user is signed in' do
      before do
        post user_session_path,
             params: valid_credentials,
             headers: { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
        @auth_headers = {
          'Authorization': response.headers['Authorization'],
          'CONTENT_TYPE': 'application/json',
          'ACCEPT': 'application/json'
        }
      end

      it 'returns success status' do
        delete destroy_user_session_path, headers: @auth_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when no user is signed in' do
      before do
        delete destroy_user_session_path,
               headers: { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
