require 'rails_helper'

describe 'Revenue API' do
  describe 'GET revenue/merchants' do
    before :each do
      merchants = create_list(:merchant, 5)
      merchants.map do |merchant|
        create(:item, merchant: merchant)
        create(:invoice, merchant: merchant, status: 'shipped')
      end
      create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
      create(:invoice_item, item: Item.second, invoice: Invoice.second, quantity: 1, unit_price: 15.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 3, unit_price: 20.00)
      create(:invoice_item, item: Item.fourth, invoice: Invoice.fourth, quantity: 1, unit_price: 13.00)
      create(:invoice_item, item: Item.fifth, invoice: Invoice.fifth, quantity: 3, unit_price: 7.00)
      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice)
      end
    end
    it 'can return quantity of merchants by revenue' do
      get "/api/v1/revenue/merchants?quantity=3"

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)
      merchants[:data].each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
        expect(merchant[:attributes]).to have_key(:revenue)
        expect(merchant[:attributes][:revenue]).to be_a(Float)
      end
    end
    it 'can return error if params are incorrect' do
      get "/api/v1/revenue/merchants"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
  describe 'GET revenue/merchant/id' do
    before :each do
      @id = create(:merchant).id
      create_list(:item, 3, merchant_id: @id)
      create_list(:invoice, 3, merchant_id: @id, status: 'shipped')

      create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
      create(:invoice_item, item: Item.second, invoice: Invoice.first, quantity: 1, unit_price: 15.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.second, quantity: 3, unit_price: 20.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 1, unit_price: 20.00)
      create(:invoice_item, item: Item.first, invoice: Invoice.third, quantity: 3, unit_price: 10.00)
      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice)
      end
    end
    it 'can return total revenue for a merchant' do
      get "/api/v1/revenue/merchants/#{@id}"
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data][:attributes]).to have_key(:revenue)
      expect(merchant[:data][:attributes][:revenue]).to be_a(Float)
      expect(merchant[:data][:attributes][:revenue]).to eq(145)
    end
  end
  describe 'GET revenue dates' do
    before :each do
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
      @start_date = "2021-09-02"
      @end_date = "2021-09-03"
    end
    it 'can return total revenue for time range' do
      get "/api/v1/revenue?start_date=#{@start_date}&end_date=#{@end_date}"
      revenue = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(revenue[:data][:attributes]).to have_key(:revenue)
      expect(revenue[:data][:attributes][:revenue]).to be_a(Float)
      expect(revenue[:data][:attributes][:revenue]).to eq(75)

      get "/api/v1/revenue?start=#{@start_date}&end=#{@end_date}"
      revenue = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(revenue[:data][:attributes]).to have_key(:revenue)
      expect(revenue[:data][:attributes][:revenue]).to be_a(Float)
      expect(revenue[:data][:attributes][:revenue]).to eq(75)
    end
    it 'returns an error if params are missing' do
      get "/api/v1/revenue?start_date="
      expect(response).to_not be_successful
      expect(response.status).to be(400)
    end
    it 'returns an error if end date is before start date' do
      get "/api/v1/revenue?start=#{@end_date}&end=#{@start_date}"
      expect(response).to_not be_successful
      expect(response.status).to be(400)

      get "/api/v1/revenue?start_date=#{@end_date}&end_date=#{@start_date}"
      expect(response).to_not be_successful
      expect(response.status).to be(400)
    end
  end
  describe 'GET revenue/items' do
    before :each do
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
    end
    it 'can return quantity of items by revenue' do
      get "/api/v1/revenue/items?quantity=3"

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)
      items[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:revenue)
        expect(item[:attributes][:revenue]).to be_a(Float)
      end
    end
    it 'returns error if params are not correct' do
      get "/api/v1/revenue/items"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/revenue/items?quantity=kdj"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
