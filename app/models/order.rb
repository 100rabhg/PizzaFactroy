class Order < ApplicationRecord
  has_many :pizzas, dependent: :destroy
  has_and_belongs_to_many :sides

  def as_json(options = {})
    super(options.merge(include: { pizzas: { include: [:crust, :toppings] } }))
  end
  accepts_nested_attributes_for :pizzas

  enum status: { pending: 0, approved: 1 }

  before_update :check_stock_for_approval, if: -> { status_changed? && status == 'approved' }
  after_save :deduct_stock, if: -> { saved_change_to_status? && status == 'approved' }

  before_create :set_default_status
  before_save :calculate_total_price

  private

  def check_stock_for_approval
    pizzas.each do |pizza|
      crust = pizza.crust
      raise ActiveRecord::RecordInvalid, "Not enough stock for crust: #{crust.name}" if crust.stock < 1

      pizza.toppings.each do |topping|
        raise ActiveRecord::RecordInvalid, "Not enough stock for topping: #{topping.name}" if topping.stock < 1
      end
    end

    sides.each do |side|
      raise ActiveRecord::RecordInvalid, "Not enough stock for side: #{side.name}" if side.stock < 1
    end
  end

  def set_default_status
    self.status ||= 'pending'
  end

  def calculate_total_price
    self.total_price = pizzas.sum do |pizza|
      pizza.price.to_f + pizza.toppings.sum { |topping| topping.price.to_f }
    end + sides.sum { |side| side.price.to_f }
  end

  def deduct_stock
    pizzas.each do |pizza|
      pizza.crust.update!(stock: pizza.crust.stock - 1)

      pizza.toppings.each do |topping|
        topping.update!(stock: topping.stock - 1)
      end
    end

    sides.each do |side|
      side.update!(stock: side.stock - 1)
    end
  end
end
