require 'rails_helper'

RSpec.describe SidesController, type: :controller do
  describe 'POST #create' do
    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          side: { name: 'Cold drink', price: 150, stock_quantity: 5 }
        }
      end

      it 'create the inventory successfully' do
        post :create, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'Cold drink', 'price' => '150.0', 'stock_quantity' => 5 })
      end
    end
  end

  describe 'PUT #update' do
    let!(:side) { Side.create!(name: 'Cold drink', price: 150, stock_quantity: 5) }

    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          id: side.id,
          side: { price: 200, stock_quantity: 10 }
        }
      end

      it 'updates the inventory successfully' do
        put :update, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'id' => side.id })

        expect(side.reload.price).to eq(200)
        expect(side.reload.stock_quantity).to eq(10)
      end
    end
  end

  describe 'GET #index' do
    context 'when valid inventory updates are provided' do
      let!(:side1) { Side.create!(name: 'Cold drink', price: 150, stock_quantity: 5) }
      let!(:side2) { Side.create!(name: 'Mousse cake', price: 200, stock_quantity: 5) }

      it 'list the inventory successfully' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          hash_including('name' => 'Cold drink', 'price' => '150.0', 'stock_quantity' => 5),
          hash_including('name' => 'Mousse cake', 'price' => '200.0', 'stock_quantity' => 5)
        )
      end
    end
  end

  describe 'GET #show' do
    context 'when valid inventory updates are provided' do
      let!(:side) { Side.create!(name: 'Cold drink', price: 150, stock_quantity: 5) }

      it 'list the inventory successfully' do
        get :show, params: { id: side.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'Cold drink', 'price' => '150.0', 'stock_quantity' => 5 })
      end
    end
  end
end
