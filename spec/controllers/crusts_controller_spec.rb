require 'rails_helper'

RSpec.describe CrustsController, type: :controller do
  describe 'POST #create' do
    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          crust: { name: 'New hand tossed', stock_quantity: 5 }
        }
      end

      it 'create the inventory successfully' do
        post :create, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'New hand tossed', 'stock_quantity' => 5 })
      end
    end
  end

  describe 'PUT #update' do
    let!(:crust) { Crust.create!(name: 'New hand tossed', stock_quantity: 5) }

    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          id: crust.id,
          crust: { stock_quantity: 10 }
        }
      end

      it 'updates the inventory successfully' do
        put :update, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'id' => crust.id })

        expect(crust.reload.stock_quantity).to eq(10)
      end
    end
  end

  describe 'GET #index' do
    context 'when valid inventory updates are provided' do
      let!(:crust1) { Crust.create!(name: 'New hand tossed', stock_quantity: 5) }
      let!(:crust2) { Crust.create!(name: 'Wheat thin crust', stock_quantity: 5) }

      it 'list the inventory successfully' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          hash_including('name' => 'New hand tossed', 'stock_quantity' => 5),
          hash_including('name' => 'Wheat thin crust', 'stock_quantity' => 5)
        )
      end
    end
  end

  describe 'GET #show' do
    context 'when valid inventory updates are provided' do
      let(:crust) { Crust.create!(name: 'New hand tossed', stock_quantity: 5) }

      it 'list the inventory successfully' do
        get :show, params: { id: crust.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include({ 'name' => 'New hand tossed', 'stock_quantity' => 5 })
      end
    end
  end
end
