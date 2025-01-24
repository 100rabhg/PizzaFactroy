require 'rails_helper'

RSpec.describe PizzasController, type: :controller do
  describe 'POST #create' do
    let!(:crust) { Crust.create!(name: 'Thin Crust') }
    let!(:topping1) { Topping.create!(name: 'Cheese', price: 2.0) }
    let!(:topping2) { Topping.create!(name: 'Pepperoni', price: 3.0) }

    context 'when valid parameters are provided' do
      let(:valid_params) do
        {
          order_id: 1,
          pizza: {
            name: 'Margherita',
            category: 'Vegetarian',
            size: 'Medium',
            price: 10.0,
            crust_id: crust.id,
            topping_ids: [topping1.id, topping2.id]
          }
        }
      end

      it 'associates the specified toppings with the pizza' do
        post :create, params: valid_params
        created_pizza = Pizza.last

        expect(created_pizza.toppings).to include(topping1, topping2)
      end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_params) do
        {
          order_id: 1,
          pizza: {
            name: '',
            category: '',
            size: '',
            price: nil,
            crust_id: nil
          }
        }
      end

      it 'does not create a pizza and returns errors' do
        expect do
          post :create, params: invalid_params
        end.not_to change(Pizza, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank", "Price can't be blank", 'Crust must exist')
      end
    end
  end
end
