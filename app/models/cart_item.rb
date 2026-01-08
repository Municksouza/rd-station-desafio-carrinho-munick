# app/models/cart_item.rb
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :sync_total_price

  private

  def sync_total_price
    return if quantity.blank? || unit_price.blank?
    self.total_price = quantity.to_i * unit_price.to_d
  end
end
