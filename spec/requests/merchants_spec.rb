require 'rails_helper'

RSpec.describe 'the Merchants API' do 
  before(:each) do 
    @merchants = create_list(:merchant, 10)
  end

  describe 'GET api/v1/merchants' do 
    it 'returns list of all merchants' do 
      get '/api/v1/merchants'

      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data].first
      attributes = data[:attributes]

      expect(response).to have_http_status(200)

      expect(json).to have_key(:data)

      expect(data).to have_key(:id)
      # expect(data[:id]).to be_a Integer

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('merchant')

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a String
    end
  end

  describe 'GET api/v1/merchants/:id' do 
    context 'merchant exists' do 
      it 'returns a single merchant based on an id' do 
        merchant = @merchants.first

        get "/api/v1/merchants/#{merchant.id}"
        
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]
        attributes = data[:attributes]

        expect(response).to have_http_status(200)

        expect(json).to have_key(:data)

        expect(data).to have_key(:id)
        expect(data[:id].to_i).to eq(merchant.id)

        expect(data).to have_key(:type)
        expect(data[:type]).to eq('merchant')

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to eq(merchant.name)
      end
    end

    context 'merchant doesnt exist' do 
      it 'returns error message and status 404' do 
        get "/api/v1/merchants/#{@merchants.last.id + 1}"
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(json[:error]).to eq('Merchant id not found')
      end
    end
  end

  describe 'GET /api/v1/merchants/:id/items' do 
    context 'merchant exists' do
      it 'returns all of a merchants items' do 
        merchant = @merchants.first
        items = create_list(:item, 10, merchant_id: merchant.id )

        get "/api/v1/merchants/#{merchant.id}/items"

        json = JSON.parse(response.body, symbolize_names: true)
        first_item = json[:data].first
        item_attributes = first_item[:attributes]

        expect(response).to have_http_status(200)

        expect(json).to have_key(:data)

        expect(first_item).to have_key(:id)
        expect(first_item[:id].to_i).to eq(items.first.id)

        expect(first_item).to have_key(:type)
        expect(first_item[:type]).to eq('item')

        expect(item_attributes).to have_key(:name)
        expect(item_attributes[:name]).to eq(items.first.name)

        expect(item_attributes).to have_key(:description)
        expect(item_attributes[:description]).to eq(items.first.description)

        expect(item_attributes).to have_key(:unit_price)
        expect(item_attributes[:unit_price]).to eq(items.first.unit_price)
      end
    end

    context 'merchant doesnt exist' do 
      it 'returns error message and status 404' do 
        get "/api/v1/merchants/#{@merchants.last.id + 20}/items"
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(404)
        expect(json[:errors]).to eq('Merchant id not found')
      end
    end
  end
end