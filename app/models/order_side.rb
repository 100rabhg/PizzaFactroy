class OrderSide < ApplicationRecord
  belongs_to :order
  belongs_to :side

  before_validation :set_price_from_side, on: :create
  validate :side_cannot_be_changed, on: :update

  private

  def side_cannot_be_changed
    errors.add(:side_id, 'cannot be changed once set') if side_id_changed?
  end

  def check_side_stock
    errors.add(:side_id, 'is out of stock') if side.stock_quantity <= 0
  end

  def set_price_from_side
    self.price ||= side.price
  end
end
