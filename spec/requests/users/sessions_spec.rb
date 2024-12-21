require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let(:user) { create(:user) } # Assumes you have a User factory
  let(:valid_credentials) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  describe 'POST /users/sign_in' do
    let(:invalid_credentials) do
      {
        user: {
          email: user.email,
          password: 'wrong_password'
        }
      }
    end

    context 'when credentials are valid' do
      before do
        post user_session_path, params: valid_credentials
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
        post user_session_path, params: invalid_credentials
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'when user is signed in' do
      before do
        post user_session_path, params: valid_credentials
        @auth_headers = { 'Authorization': response.headers['Authorization'] }
      end

      it 'returns success status' do
        delete destroy_user_session_path, headers: @auth_headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        delete destroy_user_session_path, headers: @auth_headers
        expect(json_response['message']).to eq('Logged out successfully')
      end
    end

    context 'when no user is signed in' do
      before do
        delete destroy_user_session_path
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
