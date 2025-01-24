require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:order) { Order.create!(customer_name: 'John Doe', status: 'approved', total_price: 20.0) }
  let!(:crust) { Crust.create!(name: 'Thin Crust', stock: 5) }
  let!(:topping) { Topping.create!(name: 'Mushroom', stock: 5) }
  let!(:pizza) { Pizza.create!(name: 'Margherita', crust: crust, toppings: [topping], price: 10.0, order: order) }
  let!(:side) { Side.create!(name: 'Garlic Bread', stock: 5, price: 5.0, order: order) }

  describe 'POST #create' do
    let(:valid_attributes) { { customer_name: 'Jane Doe', status: 'draft', total_price: 15.0 } }
    let(:invalid_attributes) { { customer_name: '', status: 'draft', total_price: 15.0 } }

    it 'creates a new order with valid attributes' do
      expect {
        post :create, params: { order: valid_attributes }
      }.to change(Order, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT #update_status' do
    it 'updates the order status successfully' do
      put :update_status, params: { id: order.id, status: 'confirmed' }

      expect(response).to have_http_status(:ok)
      expect(order.reload.status).to eq('confirmed')
    end

    it 'returns an error if the update fails' do
      allow_any_instance_of(Order).to receive(:update).and_return(false)

      put :update_status, params: { id: order.id, status: 'confirmed' }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #show' do
    it 'returns the order if it exists' do
      get :show, params: { id: order.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('customer_name' => order.customer_name)
    end
  end

  describe 'POST #confirm' do
    context 'when the order status is not approved' do
      it 'returns an error for draft status' do
        order.update!(status: 'draft')

        post :confirm, params: { id: order.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Order cannot be confirmed unless it is approved')
      end

      it 'returns an error for pending status' do
        order.update!(status: 'pending')

        post :confirm, params: { id: order.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Order cannot be confirmed unless it is approved')
      end
    end

    context 'when the order status is approved' do
      it 'confirms the order if inventory is sufficient' do
        post :confirm, params: { id: order.id }

        expect(response).to have_http_status(:ok)
        expect(order.reload.status).to eq('confirmed')
      end

      it 'returns an error if inventory is insufficient' do
        topping.update!(stock: 0)

        post :confirm, params: { id: order.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Insufficient inventory')
      end
    end
  end
end
