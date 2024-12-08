require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  describe 'POST /users/sign_in' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      before do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'password123'
          }
        }, as: :json
      end

      it 'returns successful login status' do
        expect(response).to have_http_status(:ok)
        expect(json_response['status']).to include(
          'code' => 200,
          'message' => 'Logged in successfully.'
        )
      end
    end

    context 'with invalid credentials' do
      before do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrongpassword'
          }
        }, as: :json
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'when user is signed in' do
      let(:user) { create(:user) }

      before do
        sign_in user
        delete destroy_user_session_path, as: :json
      end

      it 'returns successful logout message' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to include(
          'status' => 200,
          'message' => 'Logged out successfully'
        )
      end
    end

    context 'when no user is signed in' do
      before do
        delete destroy_user_session_path, as: :json
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to include(
          'status' => 401,
          'message' => "Couldn't find an active session."
        )
      end
    end
  end
end
