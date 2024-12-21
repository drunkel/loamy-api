require 'rails_helper'

RSpec.describe 'Users::Registrations', type: :request do
  describe 'POST /users' do
    let(:valid_attributes) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: 'invalid-email',
          password: 'short',
          password_confirmation: 'not-matching'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post user_registration_path,
               params: valid_attributes,
               as: :json
        }.to change(User, :count).by(1)
      end

      it 'returns a successful JSON response' do
        post user_registration_path,
             params: valid_attributes,
             as: :json

        expect(response).to have_http_status(:created)
        expect(json_response).to include(
          'message' => 'Account created successfully',
          'user' => hash_including(
            'email' => 'test@example.com'
          )
        )
      end

      it 'returns a JWT token in the authorization header' do
        post user_registration_path,
             params: valid_attributes,
             as: :json

        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to start_with('Bearer ')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect {
          post user_registration_path,
               params: invalid_attributes,
               as: :json
        }.not_to change(User, :count)
      end

      it 'returns an error JSON response' do
        post user_registration_path,
             params: invalid_attributes,
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to include(
          'message' => 'Account creation failed',
          'errors' => be_an(Array)
        )
      end
    end
  end
end
