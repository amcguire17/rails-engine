require 'rails_helper'

describe 'Items API' do
  describe 'GET items' do
    it 'returns a list of items' do
      create_list(:item, 5)
      get '/api/v1/items'

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
    it 'has a default limit of 20 and start with page 1' do
      create_list(:item, 21)
      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(20)

      item_21 = items[:data].any? do |item|
        item[:attributes][:name] == Item.last.name
      end
      expect(item_21).to be(false)
    end
    it 'returns amount per page when queried' do
      create_list(:item, 6)
      get '/api/v1/items?per_page=5'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(5)

      item_6 = items[:data].any? do |item|
        item[:attributes][:name] == Item.last.name
      end
      expect(item_6).to be(false)
    end

    it 'returns specific page when queried' do
      create_list(:item, 21)
      get '/api/v1/items?page=2'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(1)

      item_21 = items[:data].any? do |item|
        item[:attributes][:name] == Item.last.name
      end
      expect(item_21).to be(true)
    end
  end
end
