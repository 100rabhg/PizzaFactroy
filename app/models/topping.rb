class Topping < ApplicationRecord
  has_many :order_toppings, dependent: :nullify

  enum category: %i[veg non_veg other]

  validates :name, presence: true
  validates :category, presence: true
  validates :price, presence: true
  validates :stock_quantity, presence: true
end
