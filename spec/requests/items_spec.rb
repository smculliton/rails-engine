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
    it 'returns a single items information' do 
      item = items.first
      get "/api/v1/items/#{item.id}"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(json[:data]).to have_key(:attributes)
    end
  end

  describe 'POST /api/v1/items' do 
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

      expect(response).to have_http_status(200)

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  describe 'PATCH /api/v1/items/:id' do 
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

  describe 'DELETE /api/v1/items/:id' do 
    it 'deletes a single item' do 
      
    end
  end

  describe 'GET /api/v1/items/:id/merchants' do 

  end
end