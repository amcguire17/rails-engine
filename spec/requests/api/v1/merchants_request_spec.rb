require 'rails_helper'

describe 'Merchants API' do
  describe 'GET merchants' do
    it 'returns a list of merchants' do
      create_list(:merchant, 5)
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].count).to eq(5)

      merchants[:data].each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
    it 'has a default limit of 20 and start with page 1' do
      create_list(:merchant, 21)
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].count).to eq(20)

      merchant_21 = merchants[:data].any? do |merchant|
        merchant[:attributes][:name] == Merchant.last.name
      end
      expect(merchant_21).to be(false)
    end
    it 'returns amount per page when queried' do
      create_list(:merchant, 6)
      get '/api/v1/merchants?per_page=5'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].count).to eq(5)

      merchant_6 = merchants[:data].any? do |merchant|
        merchant[:attributes][:name] == Merchant.last.name
      end
      expect(merchant_6).to be(false)
    end

    it 'returns specific page when queried' do
      create_list(:merchant, 21)
      get '/api/v1/merchants?page=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].count).to eq(1)

      merchant_21 = merchants[:data].any? do |merchant|
        merchant[:attributes][:name] == Merchant.last.name
      end
      expect(merchant_21).to be(true)
    end
  end
  describe 'GET merchant by id' do
    before :each do
      @id = create(:merchant).id
    end
    it 'returns an individual merchant' do
      get "/api/v1/merchants/#{@id}"
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:id]).to eq("#{@id}")
    end
  end
  describe "GET merchant's items" do
    it 'returns a list of merchants items' do
      merchant = create(:merchant)
      create_list(:item, 5, merchant: merchant)
      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(5)

      items[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end
end
