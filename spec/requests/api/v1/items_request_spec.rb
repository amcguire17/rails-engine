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
      get '/api/v1/items?page=0'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(20)

      item_21 = items[:data].any? do |item|
        item[:attributes][:name] == Item.last.name
      end
      expect(item_21).to be(false)
    end
  end
  describe 'GET item by id' do
    before :each do
      @id = create(:item).id
    end
    it 'returns an individual merchant' do
      get "/api/v1/items/#{@id}"
      item = JSON.parse(response.body, symbolize_names: true)


      expect(response).to be_successful
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:data][:id]).to eq("#{@id}")
    end
  end
  describe "POST item" do
    it 'can create an item' do
      create(:merchant, id: 14)
      item_params = ({
                  "name": 'Candle',
                  "description": 'pine scented soy wax candle',
                  "unit_price": 15.0,
                  "merchant_id": 14
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
    it 'returns an error when param is missing' do
      create(:merchant, id: 14)
      item_params = ({
                  "name": 'Candle',
                  "unit_price": 15.0,
                  "merchant_id": 14
                })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(message[:error].first).to eq("Description can't be blank")
    end
  end
  describe "PATCH item" do
    it 'can upate an item' do
      id = create(:item).id
      previous_name = Item.last.name
      previous_price = Item.last.unit_price
      item_params = { name: 'Candle', unit_price: 1500.0 }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq('Candle')
      expect(item.unit_price).to_not eq(previous_price)
      expect(item.unit_price).to eq(1500.0)
    end
    it 'returns an error if item is not found' do
      id = create(:item).id
      item_params = { name: 'Candle', unit_price: 1500.0 }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/1500", headers: headers, params: JSON.generate({item: item_params})
      message = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(message[:error]).to eq("Couldn't find Item with 'id'=1500")
    end
    it 'returns an error if merchant is not found' do
      id = create(:item).id
      item_params = { name: 'Candle', unit_price: 1500.0, merchant_id: 1500 }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      message = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(message[:error].first).to eq("Merchant must exist")
    end
  end
  describe "DELETE item" do
    it 'can delete an item and not return any JSON' do
      id = create(:item).id

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  describe "GET item's merchant" do
    it 'returns merchant of item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      item_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(item_merchant[:data][:id]).to eq("#{merchant.id}")
      expect(item_merchant[:data][:attributes]).to have_key(:name)
      expect(item_merchant[:data][:attributes][:name]).to be_a(String)
    end
  end
  describe 'GET find' do
    before :each do
      item1 = create(:item, name: 'Hand Sanitizer', unit_price: 5.00)
      item2 = create(:item, name: 'Hand Lotion', unit_price: 10.00)
      item3 = create(:item, name: 'Soap', unit_price: 7.00)
    end
    it 'can find item by name or unit_price' do
      get "/api/v1/items/find?name=hand"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item[:data][:attributes][:name]).to eq("Hand Lotion")

      get "/api/v1/items/find?min_price=6"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item[:data][:attributes][:name]).to eq("Hand Lotion")

      get "/api/v1/items/find?max_price=6"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item[:data][:attributes][:name]).to eq("Hand Sanitizer")

      get "/api/v1/items/find?min_price=6&max_price=9"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item[:data][:attributes][:name]).to eq("Soap")
    end
    it 'returns empty hash if item is not found' do
      get "/api/v1/items/find?name=gloves"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to eq({})

      get "/api/v1/items/find?min_price=20"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to eq({})

      get "/api/v1/items/find?max_price=2"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to eq({})

      get "/api/v1/items/find?min_price=15&max_price=20"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to eq({})
    end
    it 'returns error if params are incorrect' do
      item1 = create(:item, name: 'Hand Sanitizer', unit_price: 5.00)
      item2 = create(:item, name: 'Hand Lotion', unit_price: 10.00)
      item3 = create(:item, name: 'Soap', unit_price: 7.00)

      get "/api/v1/items/find?name="

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/items/find?name=soap&max_price=2"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/items/find?max_price="

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/items/find?max_price=-5"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/items/find?min_price="

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/items/find?min_price=-5"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/items/find?max_price=2&min_price=20"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
  describe 'GET find_all' do
    it 'can find all items by name' do
      item1 = create(:item, name: 'Hand Sanitizer')
      item2 = create(:item, name: 'Hand Lotion')
      item3 = create(:item, name: 'Soap')

      get "/api/v1/items/find_all?name=hand"

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
    end
    it 'returns error if params are incorrect' do
      item1 = create(:item, name: 'Hand Sanitizer')
      item2 = create(:item, name: 'Hand Lotion')
      item3 = create(:item, name: 'Soap')

      get "/api/v1/items/find_all?name="

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
