class OrderPizzaSerializer < ActiveModel::Serializer
  attributes :id, :price, :pizza, :crust, :order_toppings

  def order_toppings
    object.order_toppings.map do |order_topping|
      OrderToppingSerializer.new(order_topping, scope: scope).as_json
    end
  end

  def pizza
    PizzaSerializer.new(object.pizza, scope: scope).as_json
  end

  def crust
    CrustSerializer.new(object.crust, scope: scope).as_json
  end
end
