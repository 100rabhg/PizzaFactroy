class CrustSerializer < ActiveModel::Serializer
  attributes :id, :name

  attribute :stock_quantity, if: -> { instance_options[:include_stock_quantity] }

  def stock_quantity
    object.stock_quantity
  end
end
