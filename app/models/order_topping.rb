class OrderTopping < ApplicationRecord
  belongs_to :order_pizza
  belongs_to :topping

  before_validation :set_price_from_topping, on: :create
  validate :topping_cannot_be_changed, on: :update

  private

  def topping_cannot_be_changed
    errors.add(:topping_id, 'cannot be changed once set') if topping_id_changed?
  end

  def check_topping_stock
    errors.add(:topping_id, 'is out of stock') if topping.stock_quantity <= 0
  end

  def set_price_from_topping
    self.price ||= topping.price
  end
end
