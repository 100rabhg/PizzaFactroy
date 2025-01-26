require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:crust1) { Crust.create!(name: 'New hand tossed', stock_quantity: 5) }
  let(:crust2) { Crust.create!(name: 'Wheat thin crust', stock_quantity: 0) }

  let(:pizza1) { Pizza.create!(name: 'Deluxe Veggie', category: :veg, size: :regular, price: 150) }
  let(:pizza2) { Pizza.create!(name: 'Non-Veg Supreme', category: :non_veg, size: :large, price: 425) }

  let(:side1) { Side.create!(name: 'Cold drink', price: 15, stock_quantity: 5) }
  let(:side2) { Side.create!(name: 'Mousse cake', price: 20, stock_quantity: 5) }

  let(:topping1) { Topping.create!(name: 'Extra cheese', price: 15, stock_quantity: 5, category: :veg) }
  let(:topping2) { Topping.create!(name: 'Paneer', price: 35, category: :veg, stock_quantity: 5) }
  let(:topping3) { Topping.create!(name: 'Grilled chicken', price: 40, category: :non_veg, stock_quantity: 5) }
  let(:topping4) { Topping.create!(name: 'Barbeque chicken', price: 45, category: :non_veg, stock_quantity: 5) }

  let(:order) { Order.create!(valid_attributes) }

  let(:valid_attributes) do
    {
      customer_name: 'Cus-1',
      order_pizzas_attributes: [
        {
          pizza_id: pizza1.id,
          crust_id: crust1.id,
          order_toppings_attributes: [
            { topping_id: topping1.id },
            { topping_id: topping2.id }
          ]
        }
      ],
      order_sides_attributes: [
        { side_id: side1.id },
        { side_id: side2.id }
      ]
    }
  end

  let(:stock_error_attr) do
    {
      customer_name: 'Cus-2',
      order_pizzas_attributes: [
        {
          pizza_id: pizza1.id,
          crust_id: crust2.id,
          order_toppings_attributes: [
            { topping_id: topping1.id },
            { topping_id: topping2.id }
          ]
        }
      ]
    }
  end

  let(:veg_pizza_non_veg_topping_attr) do
    {
      customer_name: 'Cus-2',
      order_pizzas_attributes: [
        {
          pizza_id: pizza1.id,
          crust_id: crust1.id,
          order_toppings_attributes: [
            { topping_id: topping3.id }
          ]
        }
      ]
    }
  end

  let(:non_veg_pizza_paneer_topping_attr) do
    {
      customer_name: 'Cus-2',
      order_pizzas_attributes: [
        {
          pizza_id: pizza2.id,
          crust_id: crust1.id,
          order_toppings_attributes: [
            { topping_id: topping2.id }
          ]
        }
      ]
    }
  end

  let(:non_veg_pizza_2_non_veg_topping_attr) do
    {
      customer_name: 'Cus-2',
      order_pizzas_attributes: [
        {
          pizza_id: pizza2.id,
          crust_id: crust1.id,
          order_toppings_attributes: [
            { topping_id: topping3.id },
            { topping_id: topping4.id }
          ]
        }
      ]
    }
  end

  describe 'POST #create' do
    it 'creates a new order with valid attributes' do
      expect do
        post :create, params: { order: valid_attributes }
      end.to change(Order, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('customer_name' => 'Cus-1', 'total_price' => '235.0')
    end

    it 'error Vegetarian pizza cannot have non-vegetarian toppings' do
      expect do
        post :create, params: { order: veg_pizza_non_veg_topping_attr }
      end.to change(Order, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Order pizzas Vegetarian pizza cannot have non-vegetarian toppings')
    end

    it 'error Non-vegetarian pizza cannot have paneer topping' do
      expect do
        post :create, params: { order: non_veg_pizza_paneer_topping_attr }
      end.to change(Order, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Order pizzas Non-vegetarian pizza cannot have paneer topping')
    end

    it 'error Non-Vegetarian pizza can only have one non-vegetarian topping' do
      expect do
        post :create, params: { order: non_veg_pizza_2_non_veg_topping_attr }
      end.to change(Order, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Order pizzas Non-Vegetarian pizza can only have one non-vegetarian topping')
    end
  end

  describe 'PUT #update' do
    it 'updates the order status successfully' do
      before_order_crust_qty = crust1.stock_quantity
      before_order_side_qty = side1.stock_quantity
      before_order_topping_qty = topping1.stock_quantity
      put :update, params: { id: order.id, order: { status: :confirmed } }

      expect(response).to have_http_status(:ok)
      expect(order.reload.status).to eq('accepted')
      expect(crust1.reload.stock_quantity).to eq(before_order_crust_qty - 1)
      expect(side1.reload.stock_quantity).to eq(before_order_side_qty - 1)
      expect(topping1.reload.stock_quantity).to eq(before_order_topping_qty - 1)
    end

    it 'returns an error if the update fails' do
      put :update, params: { id: order.id, order: stock_error_attr }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Order pizzas crust is out of stock')
    end
  end

  describe 'GET #show' do
    it 'returns the order if it exists' do
      get :show, params: { id: order.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('customer_name' => order.customer_name, 'total_price' => '235.0')
    end
  end
end
