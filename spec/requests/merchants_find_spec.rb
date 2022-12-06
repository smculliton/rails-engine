require 'rails_helper'

RSpec.describe 'the Merchant Search' do 
  describe 'GET /api/v1/merchants/find' do 
    it 'searches merchants by name' do 
      get '/api/v1/merchants/find', params: { name: 'mart' }
      
      expect(response).to have_http_status(200)
    end
  end
end