class PizzaSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :size, :price
end
