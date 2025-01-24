require 'rails_helper'

RSpec.describe InventoryController, type: :controller do
  describe 'POST #update' do
    let!(:crust) { Crust.create!(name: 'Thin Crust', stock: 5) }
    let!(:topping) { Topping.create!(name: 'Cheese', stock: 10) }
    let!(:side) { Side.create!(name: 'Garlic Bread', stock: 8) }

    context 'when valid inventory updates are provided' do
      let(:valid_params) do
        {
          crusts: [{ id: crust.id, stock: 10 }],
          toppings: [{ id: topping.id, stock: 15 }],
          sides: [{ id: side.id, stock: 20 }]
        }
      end

      it 'updates the inventory successfully and returns a success message' do
        post :update, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Inventory updated successfully!' })

        expect(crust.reload.stock).to eq(10)
        expect(topping.reload.stock).to eq(15)
        expect(side.reload.stock).to eq(20)
      end
    end

    context 'when a requested item is not found' do
      let(:invalid_params) do
        {
          crusts: [{ id: 999, stock: 10 }]
        }
      end

      it 'returns an error for the missing item' do
        post :update, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => a_string_including("Couldn't find Crust"))
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow_any_instance_of(Crust).to receive(:update!).and_raise(StandardError, 'Something went wrong')
      end

      let(:valid_params) do
        {
          crusts: [{ id: crust.id, stock: 10 }]
        }
      end

      it 'returns a generic error message' do
        post :update, params: valid_params

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to include('error' => 'An error occurred: Something went wrong')
      end
    end
  end
end
