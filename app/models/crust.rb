class Crust < ApplicationRecord
  validates :name, presence: true
  validates :stock_quantity, presence: true
end
