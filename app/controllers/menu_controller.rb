class MenuController < ApplicationController
  def index
    pizzas = Pizza.all
    crusts = Crust.where('stock_quantity > 0')
    toppings = Topping.where('stock_quantity > 0')
    sides = Side.where('stock_quantity > 0')

    render json: {
      pizzas: ActiveModelSerializers::SerializableResource.new(pizzas, each_serializer: PizzaSerializer),
      crusts: ActiveModelSerializers::SerializableResource.new(crusts, each_serializer: CrustSerializer),
      toppings: ActiveModelSerializers::SerializableResource.new(toppings, each_serializer: ToppingSerializer),
      sides: ActiveModelSerializers::SerializableResource.new(sides, each_serializer: SideSerializer)
    }, status: :ok
  end
end
