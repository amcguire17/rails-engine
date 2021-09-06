require 'rails_helper'

describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
  end
  describe 'class methods' do
    describe '.search' do
      it 'can return merchant by search' do
        merchant = create(:merchant, name: 'Hand Care Co')
        expect(Merchant.search('care')).to eq(merchant)
      end
    end
  end
end
