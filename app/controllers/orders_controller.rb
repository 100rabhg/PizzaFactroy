class OrdersController < ApplicationController
  include CrudController

  private

  def model
    Order
  end

  def response_object(order)
    render json: order
  end

  def permitted_params
    params.require(:order).permit(
      :customer_name, :status,
      order_pizzas_attributes: [
        :id, :pizza_id, :crust_id, :_destroy,
        { order_toppings_attributes: %i[id topping_id _destroy] }
      ],
      order_sides_attributes: %i[id side_id _destroy]
    )
  end
end
