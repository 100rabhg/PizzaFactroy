class OrderToppingSerializer < ActiveModel::Serializer
  attributes :id, :price, :topping

  def topping
    ToppingSerializer.new(object.topping, scope: scope).as_json
  end
end
