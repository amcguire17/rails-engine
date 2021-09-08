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
    describe '.min_max_price' do
      it 'can return all items by min and max price search' do
        item1 = create(:item, unit_price: 25.00)
        item2 = create(:item, unit_price: 10.00)
        item3 = create(:item, unit_price: 17.50)
        expect(Item.min_max_price(15.00, 20.00)).to eq(item3)
      end
    end
    describe '.quantity_by_revenue' do
      it 'can return specific amount of items by revenue' do
        merchant = create(:merchant)
        items = create_list(:item, 5, merchant: merchant)
        create_list(:invoice, 5, merchant: merchant, status: 'shipped')
        create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
        create(:invoice_item, item: Item.second, invoice: Invoice.second, quantity: 1, unit_price: 15.00)
        create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 3, unit_price: 20.00)
        create(:invoice_item, item: Item.fourth, invoice: Invoice.fourth, quantity: 1, unit_price: 13.00)
        create(:invoice_item, item: Item.fifth, invoice: Invoice.fifth, quantity: 3, unit_price: 7.00)
        Invoice.all.each do |invoice|
          create(:transaction, invoice: invoice)
        end

        expect(Item.quantity_by_revenue(2)).to eq([items.third, items.fifth])
      end
    end
  end
end
