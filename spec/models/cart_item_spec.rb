# spec/models/cart_item_spec.rb
require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associações (sem shoulda)' do
    it 'associa com o carrinho e o produto' do
      cart = create(:cart)
      product = create(:product, price: 7.0)

      item = described_class.create!(cart: cart, product: product, quantity: 1, unit_price: product.price)

      expect(item.cart).to eq(cart)
      expect(item.product).to eq(product)
    end
  end

  describe 'validações (quantity > 0)' do
    it 'é inválido quando quantity <= 0' do
      cart = create(:cart)
      product = create(:product, price: 7.0)

      item = described_class.new(cart: cart, product: product, quantity: 0, unit_price: product.price)

      expect(item).not_to be_valid
      expect(item.errors[:quantity]).to be_present
    end
  end

  describe '#total_price' do
    it 'retorna quantity * unit_price' do
      cart = create(:cart)
      product = create(:product, price: 7.0)
      item = described_class.create!(cart: cart, product: product, quantity: 3, unit_price: product.price)

      expect(item.total_price.to_f).to eq(21.0)
    end
  end
end
