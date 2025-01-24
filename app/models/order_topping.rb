class OrderTopping < ApplicationRecord
  belongs_to :order_pizza
  belongs_to :topping

  validates :price, presence: true
end
