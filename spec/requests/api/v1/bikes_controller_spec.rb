require 'rails_helper'

RSpec.describe Api::V1::BikesController, type: :request do
  describe 'POST /api/v1/bikes' do
    let(:user) { create(:user) }
    let(:valid_bikes_params) do
      {
        bikes: [
          {
            gear_id: 'b12345',
            name: 'Road Bike',
            last_service_date: '2024-01-15'
          },
          {
            gear_id: 'b67890',
            name: 'Mountain Bike',
            last_service_date: '2024-01-01'
          }
        ]
      }
    end
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

    context 'when user is not authenticated' do
      it 'returns unauthorized status' do
        post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'creates multiple bikes' do
          expect {
            post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: headers
          }.to change(Bike, :count).by(2)
        end

        it 'returns created status' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: headers
          expect(response).to have_http_status(:created)
        end

        it 'returns the created bikes' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: headers
          expect(response.parsed_body['bikes'].length).to eq(2)
          expect(response.parsed_body['bikes'].first['name']).to eq('Road Bike')
        end

        it 'associates bikes with the current user' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: headers
          expect(Bike.all).to all(have_attributes(user_id: user.id))
        end
      end

      context 'with invalid parameters' do
        it 'returns bad request when bikes parameter is missing' do
          post '/api/v1/bikes', params: {}.to_json, headers: headers
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns unprocessable entity when bike data is invalid' do
          post '/api/v1/bikes',
            params: { bikes: [ { name: '' } ] }.to_json,
            headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with duplicate gear_ids for the same user' do
        before do
          create(:bike, user: user, gear_id: 'b12345')
        end

        it 'returns unprocessable entity' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
