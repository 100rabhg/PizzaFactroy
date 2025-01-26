class OrderSideSerializer < ActiveModel::Serializer
  attributes :id, :price, :side

  def side
    SideSerializer.new(object.side, scope: scope).as_json
  end
end
