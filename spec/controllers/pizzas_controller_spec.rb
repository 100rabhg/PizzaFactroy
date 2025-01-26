require 'rails_helper'

RSpec.describe PizzasController, type: :controller do
  describe 'POST #create' do
    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          pizza: { name: 'Deluxe Veggie', category: :veg, size: :regular, price: 150 }
        }
      end

      it 'create the inventory successfully' do
        post :create, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'Deluxe Veggie', 'price' => '150.0' })
      end
    end
  end

  describe 'PUT #update' do
    let!(:pizza) { Pizza.create!(name: 'Deluxe Veggie', category: :veg, size: :regular, price: 150) }

    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          id: pizza.id,
          pizza: { price: 200 }
        }
      end

      it 'updates the inventory successfully' do
        put :update, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'id' => pizza.id })

        expect(pizza.reload.price).to eq(200)
      end
    end
  end

  describe 'GET #index' do
    context 'when valid inventory updates are provided' do
      let!(:pizza1) { Pizza.create!(name: 'Deluxe Veggie', category: :veg, size: :regular, price: 150) }
      let!(:pizza2) { Pizza.create!(name: 'Cheese and corn', category: :veg, size: :regular, price: 200) }

      it 'list the inventory successfully' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          hash_including('name' => 'Deluxe Veggie', 'price' => '150.0'),
          hash_including('name' => 'Cheese and corn', 'price' => '200.0')
        )
      end
    end
  end

  describe 'GET #show' do
    context 'when valid inventory updates are provided' do
      let!(:pizza) { Pizza.create!(name: 'Deluxe Veggie', category: :veg, size: :regular, price: 150) }

      it 'list the inventory successfully' do
        get :show, params: { id: pizza.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'Deluxe Veggie', 'price' => '150.0' })
      end
    end
  end
end
