class Order < ApplicationRecord
  has_many :order_pizzas, dependent: :destroy
  accepts_nested_attributes_for :order_pizzas, allow_destroy: true

  has_many :order_sides, dependent: :destroy
  accepts_nested_attributes_for :order_sides, allow_destroy: true

  enum status: %i[pending confirmed accepted]

  after_save :set_total_price, unless: :accepted?
  after_initialize :set_initial_status, if: :new_record?

  after_update :deduct_stock_after_confirmation, if: :status_changed_to_confirmed?

  private

  def set_initial_status
    self.status ||= :pending
  end

  def set_total_price
    pizzas_price = order_pizzas.sum do |order_pizza|
      base_price = order_pizza.price

      toppings_price = order_pizza.order_toppings.sum(&:price)
      toppings_price -= order_pizza.order_toppings.first(2).sum(&:price) if order_pizza.pizza.size == 'large'

      base_price + toppings_price
    end

    sides_price = order_sides.sum(&:price)

    update_columns(total_price: pizzas_price + sides_price)
  end

  def status_changed_to_confirmed?
    saved_change_to_status? && status == 'confirmed'
  end

  def deduct_stock_after_confirmation
    order_pizzas.each do |order_pizza|
      order_pizza.crust.lock!

      if order_pizza.crust.stock_quantity.positive?
        order_pizza.crust.update!(stock_quantity: order_pizza.crust.stock_quantity - 1)
      else
        errors.add(:base, "Insufficient stock for crust #{order_pizza.crust.name}")
        throw :abort
      end

      order_pizza.order_toppings.each do |order_topping|
        order_topping.topping.lock!

        if order_topping.topping.stock_quantity.positive?
          order_topping.topping.update!(stock_quantity: order_topping.topping.stock_quantity - 1)
        else
          errors.add(:base, "Insufficient stock for topping #{order_topping.topping.name}")
          throw :abort
        end
      end
    end

    order_sides.each do |order_side|
      order_side.side.lock!

      if order_side.side.stock_quantity.positive?
        order_side.side.update!(stock_quantity: order_side.side.stock_quantity - 1)
      else
        errors.add(:base, "Insufficient stock for side #{order_side.side.name}")
        throw :abort
      end
    end

    update_columns(status: :accepted)
  end
end
