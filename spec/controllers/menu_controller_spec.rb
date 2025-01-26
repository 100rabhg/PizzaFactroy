require 'rails_helper'

RSpec.describe MenuController, type: :controller do
  describe 'GET #index' do
    before do
      @crust = Crust.create!(name: 'New hand tossed', stock_quantity: 5)
      @pizza = Pizza.create!(name: 'Deluxe Veggie', category: :veg, size: :regular, price: 150)
      @topping = Topping.create!(name: 'Extra cheese', price: 35, category: :other, stock_quantity: 5)
      @side = Side.create!(name: 'Cold drink', price: 55, stock_quantity: 5)
    end

    it 'returns the correct JSON structure' do
      get :index

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response).to include(
        'pizzas' => [
          hash_including('id' => @pizza.id, 'name' => @pizza.name, 'category' => @pizza.category, 'size' => @pizza.size, 'price' => @pizza.price.to_s)
        ],
        'crusts' => [
          hash_including('id' => @crust.id, 'name' => @crust.name)
        ],
        'toppings' => [
          hash_including('id' => @topping.id, 'name' => @topping.name, 'category' => @topping.category, 'price' => @topping.price.to_s)
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
