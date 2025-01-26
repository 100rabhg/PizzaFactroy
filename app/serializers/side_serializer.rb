class SideSerializer < ActiveModel::Serializer
  attributes :id, :name, :price

  attribute :stock_quantity, if: -> { instance_options[:include_stock_quantity] }

  def stock_quantity
    object.stock_quantity
  end
end
