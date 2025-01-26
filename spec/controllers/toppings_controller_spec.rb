require 'rails_helper'

RSpec.describe ToppingsController, type: :controller do
  describe 'POST #create' do
    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          topping: { name: 'Extra cheese', price: 150, stock_quantity: 5, category: :veg }
        }
      end

      it 'create the inventory successfully' do
        post :create, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'Extra cheese', 'price' => '150.0', 'stock_quantity' => 5, 'category' => 'veg'})
      end
    end
  end

  describe 'PUT #update' do
    let!(:topping) { Topping.create!(name: 'Extra cheese', price: 150, stock_quantity: 5, category: :veg) }

    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          id: topping.id,
          topping: { price: 200, stock_quantity: 10 }
        }
      end

      it 'updates the inventory successfully' do
        put :update, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'id' => topping.id })

        expect(topping.reload.price).to eq(200)
        expect(topping.reload.stock_quantity).to eq(10)
      end
    end
  end

  describe 'GET #index' do
    context 'when valid inventory updates are provided' do
      let!(:topping1) { Topping.create!(name: 'Extra cheese', price: 150, stock_quantity: 5, category: :veg) }
      let!(:topping2) { Topping.create!(name: 'Black olive', price: 200, stock_quantity: 5, category: :veg) }

      it 'list the inventory successfully' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          hash_including('name' => 'Extra cheese', 'price' => '150.0', 'stock_quantity' => 5, 'category' => 'veg'),
          hash_including('name' => 'Black olive', 'price' => '200.0', 'stock_quantity' => 5, 'category' => 'veg')
        )
      end
    end
  end

  describe 'GET #show' do
    context 'when valid inventory updates are provided' do
      let!(:topping) { Topping.create!(name: 'Extra cheese', price: 150, stock_quantity: 5, category: :veg) }

      it 'list the inventory successfully' do
        get :show, params: { id: topping.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'Extra cheese', 'price' => '150.0', 'stock_quantity' => 5, 'category' => 'veg'})
      end
    end
  end
end
