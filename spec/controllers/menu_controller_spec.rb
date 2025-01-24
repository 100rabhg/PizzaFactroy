require 'rails_helper'

RSpec.describe MenuController, type: :controller do
  describe 'GET #index' do
    before do
      crust = Crust.create!(name: 'Thin Crust')
      order = Order.create!(status: 'Pending') # Replace with valid attributes for Order

      @pizza = Pizza.create!(name: 'Margherita', price: 10.0, crust: crust, order: order)
      @topping = Topping.create!(name: 'Cheese', price: 2.0)
      @side = Side.create!(name: 'Garlic Bread', price: 5.0)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct JSON structure' do
      get :index

      json_response = JSON.parse(response.body)

      expect(json_response).to include(
        'pizzas' => [
          hash_including('id' => @pizza.id, 'name' => @pizza.name, 'price' => @pizza.price.to_s)
        ],
        'crusts' => [
          hash_including('id' => @pizza.crust.id, 'name' => @pizza.crust.name)
        ],
        'toppings' => [
          hash_including('id' => @topping.id, 'name' => @topping.name, 'price' => @topping.price.to_s)
        ],
        'sides' => [
          hash_including('id' => @side.id, 'name' => @side.name, 'price' => @side.price.to_s)
        ]
      )
    end

    it 'returns an empty array if no data exists' do
      Pizza.delete_all
      Crust.delete_all
      Topping.delete_all
      Side.delete_all

      get :index

      json_response = JSON.parse(response.body)
      expect(json_response['pizzas']).to eq([])
      expect(json_response['crusts']).to eq([])
      expect(json_response['toppings']).to eq([])
      expect(json_response['sides']).to eq([])
    end
  end
end
