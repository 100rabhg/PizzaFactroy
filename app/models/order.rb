class Order < ApplicationRecord
  has_many :pizzas
  has_many :sides

  def total_price
    pizzas_total = pizzas.sum do |pizza|
      (pizza.price || 0) + pizza.toppings.sum { |topping| topping.price || 0 }
    end

    sides_total = sides.sum { |side| side.price || 0 }
    pizzas_total + sides_total
  end
end
