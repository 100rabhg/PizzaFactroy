class Topping < ApplicationRecord
  has_many :order_toppings

  enum category: %i[veg non_veg other]
end
