require 'rails_helper'

describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end
  describe 'class methods' do
    describe '.search' do
      it 'can return merchant by search' do
        merchant = create(:merchant, name: 'Hand Care Co')
        expect(Merchant.search('care')).to eq(merchant)
      end
    end
    describe '.quantity_by_items' do
      it 'can return specific amount of merchants by items sold' do
        merchants = create_list(:merchant, 3)
        merchants.map do |merchant|
          create(:item, merchant: merchant)
          create(:invoice, merchant: merchant, status: 'shipped')
        end
        create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 1, unit_price: 10.00)
        create(:invoice_item, item: Item.second, invoice: Invoice.second, quantity: 3, unit_price: 15.00)
        create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 2, unit_price: 20.00)
        Invoice.all.each do |invoice|
          create(:transaction, invoice: invoice)
        end
        expect(Merchant.quantity_by_items(2)).to eq([merchants.second, merchants.third])
      end
    end
  end
end
