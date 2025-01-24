class Order < ApplicationRecord
  has_many :pizzas, dependent: :destroy
  accepts_nested_attributes_for :pizzas
  has_and_belongs_to_many :sides

  def as_json(options = {})
    super(options.merge(include: { pizzas: { include: [:crust, :toppings] } }))
  end
end
