class PizzasController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    order = Order.find_or_create_by(id: params[:order_id])

    pizza = Pizza.new(pizza_params)
    pizza.order = order

    if pizza.save
      if params[:pizza][:topping_ids].present?
        toppings = Topping.where(id: params[:pizza][:topping_ids])
        pizza.toppings << toppings
      end

      render json: order, status: :created
    else
      render json: { errors: pizza.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def pizza_params
    params.require(:pizza).permit(:name, :category, :size, :price, :crust_id)
  end

  def filtered_pizza(pizza)
    pizza.as_json(except: %i[created_at updated_at]).merge(
      category: pizza.category,
      crust: pizza.crust.as_json(only: %i[id name]),
      toppings: pizza.toppings.pluck(:name)
    )
  end
end
