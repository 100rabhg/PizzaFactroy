class OrderSerializer < ActiveModel::Serializer
  attributes :id, :customer_name, :status, :total_price, :created_at, :pizzas, :sides

  def total_price
    object.total_price
  end

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  def pizzas
    object.pizzas.map do |pizza|
      {
        id: pizza.id,
        name: pizza.name,
        size: pizza.size,
        price: pizza.price,
        crust: pizza.crust.as_json(only: %i[id name]),
        toppings: pizza.toppings.map { |topping| topping.as_json(only: %i[id name]) }
      }
    end
  end

  def sides
    object.sides.map do |side|
      {
        id: side.id,
        name: side.name,
        price: side.price
      }
    end
  end
end




