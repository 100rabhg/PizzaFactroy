class Order < ApplicationRecord
  has_many :order_pizzas, dependent: :destroy
  accepts_nested_attributes_for :order_pizzas

  has_and_belongs_to_many :order_sides
  accepts_nested_attributes_for :order_sides

  enum status: %i[pending confirmed accept]
end
