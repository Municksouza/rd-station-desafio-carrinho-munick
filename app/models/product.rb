# app/models/product.rb
class Product < ApplicationRecord
  has_many :cart_items, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
