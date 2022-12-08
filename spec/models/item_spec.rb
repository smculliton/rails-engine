require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to :merchant }
  it { should have_many :invoice_items}
  it { should have_many(:invoices).through(:invoice_items) }

  describe 'class methods' do 
    describe '#search_all_by_name' do 
      before(:each) do 
        @merchant = create(:merchant)
        @items = create_list(:item, 5, merchant_id: @merchant.id)
        @item = @items.first
      end

      it 'returns all items that match search keyword' do 
        search = Item.search_all_by_name(@item.name)
        expect(search).to include(@item)
        expect(search).to_not include(@items.last)
      end

      it 'returns partial matches' do 
        keyword = @item.name.chop
        search = Item.search_all_by_name(keyword)
        expect(search).to include(@item)
      end

      it 'is case insensitive' do 
        keyword = @item.name.upcase
        search = Item.search_all_by_name(keyword)
        expect(search).to include(@item)
      end
    end 

    describe '#search_all_by_price' do 
      before(:each) do 
        @merchant = create(:merchant)
        @items = create_list(:item, 10, merchant_id: @merchant.id)
        @items_above_50 = @items.select { |item| item.unit_price >= 50 }
        @items_below_50 = @items.select { |item| item.unit_price <= 50 }
        @items_between_25_75 = @items.select { |item| item.unit_price <= 75 && item.unit_price >= 25 }
      end

      it 'returns all items above min price' do 
        expect(Item.search_all_by_price(50, nil)).to eq(@items_above_50)
      end

      it 'returns all items below max price' do 
        expect(Item.search_all_by_price(nil, 50)).to eq(@items_below_50)
      end

      it 'returns all items between min and max price' do 
        expect(Item.search_all_by_price(25, 75)).to eq(@items_between_25_75)
      end
    end
  end
end 
