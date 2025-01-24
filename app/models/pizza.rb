class Pizza < ApplicationRecord
  has_many :order_pizzas
  has_many :order, through: :order_pizzas

  validates :name, presence: true
  validates :price, presence: true

  enum category: %i[veg non_veg]
  enum size: %i[regular medium large]
end
