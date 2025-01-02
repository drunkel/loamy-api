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
      before { login_user(user) }

      context 'with valid parameters' do
        it 'creates multiple bikes' do
          expect {
            post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: auth_headers
          }.to change(Bike, :count).by(2)
        end

        it 'returns created status' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: auth_headers
          expect(response).to have_http_status(:created)
        end

        it 'returns the created bikes' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: auth_headers
          expect(response.parsed_body['bikes'].length).to eq(2)
          expect(response.parsed_body['bikes'].first['name']).to eq('Road Bike')
        end

        it 'associates bikes with the current user' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: auth_headers
          expect(Bike.all).to all(have_attributes(user_id: user.id))
        end
      end

      context 'with duplicate gear_ids for the same user' do
        before do
          create(:bike, user: user, gear_id: 'b12345')
        end

        it 'returns unprocessable entity' do
          post '/api/v1/bikes', params: valid_bikes_params.to_json, headers: auth_headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /api/v1/bikes/:id' do
    let(:user) { create(:user) }
    let(:bike) { create(:bike, user: user) }

    before { login_user(user) }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          bike: {
            name: 'Updated Bike Name'
          }
        }
      end

      it 'updates the bike' do
        patch api_v1_bike_path(bike), params: valid_params.to_json, headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(json_response["bike"]["name"]).to eq('Updated Bike Name')
        expect(bike.reload.name).to eq('Updated Bike Name')
      end
    end

    context 'when bike does not belong to user' do
      let(:other_user_bike) { create(:bike) }

      it 'returns not found status' do
        patch api_v1_bike_path(other_user_bike),
              params: { "bike": { "name": "New Name" } }.to_json,
              headers: auth_headers

        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq('Bike not found')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          bike: {
            name: '' # assuming name can't be blank
          }
        }
      end

      it 'returns unprocessable entity status' do
        patch api_v1_bike_path(bike), params: invalid_params, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error]).to include("Name can't be blank")
      end
    end

    context 'without authentication' do
      it 'returns unauthorized status' do
        patch api_v1_bike_path(bike), params: { bike: { name: 'New Name' } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
