class MenuController < ApplicationController
  def index
    pizzas = Pizza.select(:id, :name, :price)
    crusts = Crust.select(:id, :name)
    toppings = Topping.select(:id, :name, :price)
    sides = Side.select(:id, :name, :price)

    render json: {
      pizzas: pizzas,
      crusts: crusts,
      toppings: toppings,
      sides: sides
    }, status: :ok
  end
end
