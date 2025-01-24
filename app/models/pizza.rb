class Pizza < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  belongs_to :crust
  has_many :pizza_toppings
  has_many :toppings, through: :pizza_toppings
  belongs_to :order
end
