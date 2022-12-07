require 'rails_helper'

RSpec.describe 'the Merchant Search' do 
  let!(:merchants) { create_list(:merchant, 10) }

  describe 'GET /api/v1/merchants/find' do 
    it 'searches merchants by name' do 
      keyword = merchants.first.name
      get '/api/v1/merchants/find', params: { name: keyword }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data]).to be_a Hash

      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to be_a Hash

      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
    end

    describe 'sad paths' do 
      it 'returns empty hash if no matches' do 
        get '/api/v1/merchants/find', params: { name: '###' }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(200)

        expect(json[:data][:id]).to eq(nil)
      end
    end
  end
end