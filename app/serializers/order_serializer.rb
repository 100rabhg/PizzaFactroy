class OrderSerializer < ActiveModel::Serializer
  attributes :id, :customer_name, :status, :total_price, :created_at, :pizzas, :sides

  def total_price
    object.total_price
  end

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  def pizzas
    object.order_pizzas.map do |order_pizza|
      {
        id: order_pizza.id,
        name: order_pizza.pizza.name,
        size: order_pizza.pizza.size,
        price: order_pizza.price,
        crust: order_pizza.crust.as_json(only: %i[id name]),
        toppings: order_pizza.order_toppings.map { |order_topping| order_topping.topping.as_json(only: %i[id name]) }
      }
    end
  end

  def sides
    object.order_sides.map do |order_side|
      {
        id: order_side.id,
        name: order_side.side.name,
        price: order_side.price
      }
    end
  end
end
