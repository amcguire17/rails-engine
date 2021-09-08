require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end
  describe 'class methods' do
    describe '.revenue_by_date' do
      it 'can return total revenue within date range' do
        merchants = create_list(:merchant, 3)
        n = 1
        merchants.map do |merchant|
          create(:item, merchant: merchant)
          create(:invoice, merchant: merchant, status: 'shipped', created_at: "2021-09-#{n}")
          n += 1
        end
        create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
        create(:invoice_item, item: Item.second, invoice: Invoice.second, quantity: 1, unit_price: 15.00)
        create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 3, unit_price: 20.00)
        Invoice.all.each do |invoice|
          create(:transaction, invoice: invoice)
        end
        start_date = "2021-09-02"
        end_date = "2021-09-03"
        expect(Invoice.revenue_by_date(start_date, end_date)).to eq(75.00)
      end
    end
  end
end
