require 'rails_helper'

RSpec.describe 'the Item search' do 
  let!(:merchant) { create(:merchant) }

  describe 'GET /api/v1/items/find_all' do 
    before(:each) do 
      @item1 = create(:item, name: 'Itemy Thing', merchant_id: merchant.id)
      @item2 = create(:item, name: 'Proitem Thing', merchant_id: merchant.id)
      @item3 = create(:item, name: 'Not a Thing', merchant_id: merchant.id)
      @items = [@item1, @item2, @item3]
    end

    describe 'search by name' do 
      it 'searches for all items that match a search query' do 
        get '/api/v1/items/find_all', params: {name: 'Item'}

        json = JSON.parse(response.body, symbolize_names: true)
        item_names = json[:data].map { |item| item[:attributes][:name] }

        expect(response).to have_http_status(200)

        expect(item_names).to include(@item1.name)
        expect(item_names).to include(@item2.name)
        expect(item_names).to_not include(@item3.name)
      end
    end

    describe 'search by min price' do 
      it 'searches for all items above a price' do 
        create_list(:item, 10, merchant_id: merchant.id)
        expected_items = @items.select { |item| item.unit_price >= 50 }

        get '/api/v1/items/find_all', params: {min_price: 50}

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(expected_items.count).to eq(json[:data].count)
      end
    end
  end
end