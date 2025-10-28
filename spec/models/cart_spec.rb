require "rails_helper"

RSpec.describe Cart, type: :model do
  let(:cart)    { create(:cart) }
  let(:product) { create(:product, price: 10) }

  it "adiciona item novo e recalcula total" do
    cart.add_item!(product_id: product.id, quantity: 2)
    expect(cart.cart_items.count).to eq(1)
    expect(cart.total_price).to eq(20)
  end

  it "incrementa quantidade se item já existe" do
    create(:cart_item, cart:, product:, quantity: 1, unit_price: 10)
    cart.add_item!(product_id: product.id, quantity: 2)
    expect(cart.cart_items.first.quantity).to eq(3)
    expect(cart.total_price).to eq(30)
  end

  it "não aceita quantidade <= 0" do
    expect { cart.add_item!(product_id: product.id, quantity: 0) }
      .to raise_error(ArgumentError)
  end

  it "remove produto e atualiza total" do
    create(:cart_item, cart:, product:, quantity: 2, unit_price: 10)
    cart.remove_product!(product_id: product.id)
    expect(cart.cart_items).to be_empty
    expect(cart.total_price).to eq(0)
  end
end