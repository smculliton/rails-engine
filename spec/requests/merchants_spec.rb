require 'rails_helper'

RSpec.describe 'the Merchants API' do 
  describe 'GET /merchants' do 
    it 'returns list of all merchants' do 
      get '/merchants'

      expect(response).to have_http_status(200)
    end
  end
end