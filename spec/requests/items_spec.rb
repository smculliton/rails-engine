require 'rails_helper'

RSpec.describe 'Items API' do 
  let!(:merchant) { create(:merchant) }
  let(:merchant_id) { merchant.id }
  let!(:items) { create_list(:item, 5, merchant_id: merchant_id) }

  describe 'GET /api/v1/items' do 
    it 'returns a list of all items' do 
      get '/api/v1/items'
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(200)

      expect(json[:data].count).to eq(5)
    end
  end

  describe 'GET /api/v1/items/:id' do 
    context 'item exists' do 
      it 'returns a single items information' do 
        item = items.first
        get "/api/v1/items/#{item.id}"
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(json[:data]).to have_key(:attributes)
      end
    end

    context 'item doesnt exist' do 
      it 'returns error message and status 404' do 
        get "/api/v1/items/#{items.last.id + 1}"
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(json[:error]).to eq('Item id not found')
      end
    end
  end

  describe 'POST /api/v1/items' do 
    context 'it is successful' do
      it 'creates a new item' do 
        item_params = {
          name: 'A Thing',
          description: 'A really cool thing',
          unit_price: 19.99,
          merchant_id: merchant_id
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v1/items/', headers: headers, params: item_params.to_json
        created_item = Item.last

        expect(response).to have_http_status(201)

        expect(created_item.name).to eq(item_params[:name])
        expect(created_item.description).to eq(item_params[:description])
        expect(created_item.unit_price).to eq(item_params[:unit_price])
        expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      end
    end

    context 'it is unsuccessful' do 
      it 'returns status 404' do 
        item_params = {
          name: 'A Thing',
          description: 'A really cool thing',
          unit_price: 19.99,
          merchant_id: merchant_id + 1
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v1/items/', headers: headers, params: item_params.to_json
        json = JSON.parse(response.body, symbolize_names: true) 

        expect(response).to have_http_status(404)
        expect(json[:error]).to eq('Invalid item params')
      end
    end
  end

  describe 'PATCH /api/v1/items/:id' do 
    context 'it succesfully updates' do 
      it 'updates an existing item' do 
        item_params = {
          name: 'A Thing'
        }
        headers = {"CONTENT_TYPE" => "application/json"}
        item = items.first

        patch "/api/v1/items/#{item.id}", headers: headers, params: item_params.to_json
        updated_item = Item.find(item.id)

        expect(response).to have_http_status(200)

        expect(updated_item.name).to eq(item_params[:name])
      end
    end

    context 'it is unsuccessful' do 
      it 'returns error message and status code 404' do 
        item_params = {
          name: 'A Thing',
          description: 'A really cool thing',
          unit_price: 19.99,
          merchant_id: merchant_id + 1
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v1/items/', headers: headers, params: item_params.to_json
        json = JSON.parse(response.body, symbolize_names: true) 

        expect(response).to have_http_status(404)
        expect(json[:error]).to eq('Invalid item params')
      end
    end
  end

  describe 'DELETE /api/v1/items/:id' do 
    context 'item id exists' do 
      it 'destroys a single item' do 
        item = items.first

        delete "/api/v1/items/#{item.id}"

        expect(response).to have_http_status(204)
        expect(Item.count).to eq(4)
        expect{ Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'item id doesnt exist' do 
      it 'returns status 404' do
        delete "/api/v1/items/#{items.last.id + 1}"

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /api/v1/items/:id/merchant' do 
    context 'item exists' do 
      it 'shows the merchant that is related to an item' do 
        item = items.first

        get "/api/v1/items/#{item.id}/merchant"
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(200)
        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes][:name]).to eq(merchant.name)
      end
    end

    context 'item doesnt exist' do 
      it 'returns status 404 and error code' do 
        get "/api/v1/items/#{items.last.id + 1}/merchant"
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(json[:errors]).to eq('Item id not found')
      end
    end
  end
end