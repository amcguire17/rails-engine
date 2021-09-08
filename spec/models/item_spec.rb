require 'rails_helper'

describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:unit_price) }
  end
  describe 'class methods' do
    describe '.search_all' do
      it 'can return all items by name search' do
        item1 = create(:item, name: 'Hand Sanitizer')
        item2 = create(:item, name: 'Hand Lotion')
        item3 = create(:item, name: 'Soap')
        expect(Item.search_all('hand')).to eq([item2, item1])
      end
    end
    describe '.min_price' do
      it 'can return all items by min price search' do
        item1 = create(:item, unit_price: 25.00)
        item2 = create(:item, unit_price: 10.00)
        item3 = create(:item, unit_price: 17.50)
        expect(Item.min_price(20.00)).to eq(item1)
      end
    end
    describe '.max_price' do
      it 'can return all items by max price search' do
        item1 = create(:item, unit_price: 25.00)
        item2 = create(:item, unit_price: 10.00)
        item3 = create(:item, unit_price: 17.50)
        expect(Item.max_price(15.00)).to eq(item2)
      end
    end
  end
end
