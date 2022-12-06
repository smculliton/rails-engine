require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many :items }

  describe 'class methods' do 
    describe '#search' do 
      before(:each) do 
        @merchant1 = create(:merchant, name: 'Ring World')
        @merchant2 = create(:merchant, name: 'Turing')
        @merchant3 = create(:merchant, name: 'BRING THE HEAT')
        @merchant4 = create(:merchant, name: 'Necklace Universe')
      end
      
      it 'returns first result by alphabetical order of case insensitive search' do 
        expect(Merchant.search('ring')).to eq(@merchant3)
        expect(Merchant.search('neck')).to eq(@merchant4)
        expect(Merchant.search('u')).to eq(@merchant4)
      end
    end
  end
end
