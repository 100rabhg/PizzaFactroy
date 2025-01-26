class OrderSerializer < ActiveModel::Serializer
  attributes :id, :customer_name, :status, :total_price, :created_at

  has_many :order_pizzas, serializer: OrderPizzaSerializer
  has_many :order_sides, serializer: OrderSideSerializer

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
