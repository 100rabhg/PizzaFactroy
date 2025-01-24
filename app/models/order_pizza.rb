class OrderPizza < ApplicationRecord
  belongs_to :order
  belongs_to :pizza

  belongs_to :crust
  has_many :order_toppings
  accepts_nested_attributes_for :order_toppings

  validates :price, presence: true
end
