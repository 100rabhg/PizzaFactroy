class Side < ApplicationRecord
  has_many :order_sides, dependent: :nullify
  has_many :order, through: :order_sides

  validates :name, presence: true
  validates :price, presence: true
  validates :stock_quantity, presence: true
end
