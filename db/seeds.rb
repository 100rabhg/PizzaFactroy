# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
# #   end
# Pizza.create(name: "Deluxe Veggie", category: "Vegetarian", size: "Medium", price: 200)
# Pizza.create(name: "Non-Veg Supreme", category: "Non-Vegetarian", size: "Large", price: 425)

# Veg Pizza
Pizza.create!([
  { name: "Deluxe Veggie", category: :veg, size: :regular, price: 150},
  { name: "Deluxe Veggie", category: :veg, size: :medium, price: 200},
  { name: "Deluxe Veggie", category: :veg, size: :large, price: 325},
  { name: "Cheese and corn", category: :veg, size: :regular, price: 175},
  { name: "Cheese and corn", category: :veg, size: :medium, price: 375},
  { name: "Cheese and corn", category: :veg, size: :large, price: 475},
  { name: "Paneer Tikka", category: :veg, size: :regular, price: 160},
  { name: "Paneer Tikka", category: :veg, size: :medium, price: 290},
  { name: "Paneer Tikka", category: :veg, size: :large, price: 340},
])

# Non-veg Pizza

Pizza.create!([
  { name: "Non-Veg Supreme", category: :non_veg, size: :regular, price: 190},
  { name: "Non-Veg Supreme", category: :non_veg, size: :medium, price: 325},
  { name: "Non-Veg Supreme", category: :non_veg, size: :large, price: 425},
  { name: "Chicken Tikka", category: :non_veg, size: :regular, price: 210},
  { name: "Chicken Tikka", category: :non_veg, size: :medium, price: 370},
  { name: "Chicken Tikka", category: :non_veg, size: :large, price: 500},
  { name: "Pepper Barbecue Chicken", category: :non_veg, size: :regular, price: 220},
  { name: "Pepper Barbecue Chicken", category: :non_veg, size: :medium, price: 380},
  { name: "Pepper Barbecue Chicken", category: :non_veg, size: :large, price: 525},
])

# Crusts
Crust.create!([
  { name: "New hand tossed", stock_qunantity: 5},
  { name: "Wheat thin crust", stock_qunantity: 5},
  { name: "Cheese Burst", stock_qunantity: 5 },
  { name: "Fresh pan pizza", stock_qunantity: 5}
])

# Veg Toppings
Topping.create!([
  { name: "Black olive", price: 20, category: :veg, stock_qunantity: 5},
  { name: "Capsicum", price: 25, category: :veg, stock_qunantity: 5},
  { name: "Paneer", price: 35, category: :veg, stock_qunantity: 5},
  { name: "Mushroom", price: 30, category: :veg, stock_qunantity: 5},
  { name: "Fresh tomato", price: 10, category: :veg, stock_qunantity: 5}
])

# Non-Veg Toppings
Topping.create!([
  { name: "Chicken tikka", price: 35, category: :non_veg, stock_qunantity: 5},
  { name: "Barbeque chicken", price: 45, category: :non_veg, stock_qunantity: 5},
  { name: "Grilled chicken", price: 40, category: :non_veg, stock_qunantity: 5},
])

# other Toppings
Topping.create!(name: 'Extra cheese', price: 35, category: :other, stock_qunantity: 5)

# Sides
Side.create!([
  { name: "Cold drink", price: 55, stock_qunantity: 5},
  { name: "Mousse cake", price: 90, stock_qunantity: 5}
])
