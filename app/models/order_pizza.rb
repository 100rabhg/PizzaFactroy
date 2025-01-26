class OrderPizza < ApplicationRecord
  belongs_to :order
  belongs_to :pizza

  belongs_to :crust
  has_many :order_toppings, dependent: :destroy
  accepts_nested_attributes_for :order_toppings, allow_destroy: true

  before_validation :set_price_from_pizza, on: :create
  validate :pizza_cannot_be_changed, on: :update
  validate :pizza_crust_cannot_be_changed, on: :update
  validate :check_crust_stock, on: %i[create update]
  validate :valid_toppings_for_vegetarian_pizza
  validate :valid_topping_for_non_veg_pizza

  private

  def pizza_cannot_be_changed
    errors.add(:pizza_id, 'cannot be changed once set') if pizza_id_changed?
  end

  def pizza_crust_cannot_be_changed
    errors.add(:crust_id, 'cannot be changed once set') if crust_id_changed?
  end

  def check_crust_stock
    errors.add(:crust_id, 'is out of stock') if crust.stock_quantity <= 0
  end

  def set_price_from_pizza
    self.price ||= pizza.price
  end

  def valid_toppings_for_vegetarian_pizza
    return unless pizza.veg?

    non_veg_toppings = order_toppings.select { |order_topping| order_topping.topping.non_veg? }
    errors.add(:base, 'Vegetarian pizza cannot have non-vegetarian toppings') if non_veg_toppings.any?
  end

  def valid_topping_for_non_veg_pizza
    return unless pizza.non_veg?

    paneer_toppings = order_toppings.select { |order_topping| order_topping.topping.name.downcase == 'paneer' }
    errors.add(:base, 'Non-vegetarian pizza cannot have paneer topping') if paneer_toppings.any?

    non_veg_toppings = order_toppings.select { |order_topping| order_topping.topping.non_veg? }
    errors.add(:base, 'Non-Vegetarian pizza can only have one non-vegetarian topping') if non_veg_toppings.count > 1
  end
end
