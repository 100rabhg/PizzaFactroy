class Side < ApplicationRecord
  has_many :order_sides
  has_many :order, through: :order_sides

  validates :name, presence: true
  validates :price, presence: true
end
