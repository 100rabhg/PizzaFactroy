class ApplicationController < ActionController::Base
  
  private

  def format_order(order)
    {
      id: order.id,
      customer_name: order.customer_name,
      status: order.status,
      pizzas: order.pizzas.map do |pizza|
        {
          id: pizza.id,
          name: pizza.name,
          size: pizza.size,
          price: pizza.price,
          crust: pizza.crust.as_json(only: [:id, :name]), 
          toppings: pizza.toppings.map { |topping| topping.as_json(only: [:id, :name]) }
        }
      end,
      sides: order.sides.map do |side|
        {
          id: side.id,
          name: side.name,
          price: side.price
        }
      end,
      total_price: calculate_total_price(order),
      created_at: order.created_at.strftime('%Y-%m-%d %H:%M:%S') 
    }
  end


  def calculate_total_price(order)
    pizzas_total = order.pizzas.sum do |pizza|
      (pizza.price || 0) + pizza.toppings.sum { |topping| topping.price || 0 }
    end

    sides_total = order.sides.sum { |side| side.price || 0 }
    pizzas_total + sides_total
  end
end
