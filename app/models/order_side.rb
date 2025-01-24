class OrderPizza < ApplicationRecord
  belongs_to :order
  belongs_to :side

  validates :price, presence: true
end
