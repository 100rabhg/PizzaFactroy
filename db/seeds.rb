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
# Crusts
Crust.create([
  { name: "New hand tossed" },
  { name: "Wheat thin crust" },
  { name: "Cheese Burst" },
  { name: "Fresh pan pizza" }
])

# Toppings
Topping.create([
  { name: "Black olive", price: 20 },
  { name: "Capsicum", price: 25 },
  { name: "Paneer", price: 35 },
  { name: "Mushroom", price: 30 },
  { name: "Fresh tomato", price: 10 }
])

# Sides
Side.create!([
  { name: "Cold drink", price: 55 },
  { name: "Mousse cake", price: 90 }
])
