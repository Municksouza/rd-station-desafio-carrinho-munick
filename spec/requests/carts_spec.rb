require 'rails_helper'

RSpec.describe "Carts API", type: :request do
  describe "POST /api/cart" do
    it "cria carrinho na sessão e adiciona item" do
      product = Product.create!(name: "Produto Teste", price: 10.0)
      post "/api/cart/add_item", params: { product_id: product.id, quantity: 2 }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["products"].first["quantity"]).to eq(2)
    end
  end

  describe "GET /api/cart" do
    it "lista itens do carrinho" do
      get "/api/cart"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to have_key("products")
    end
  end

  describe "POST /api/cart/add_item" do
    it "altera quantidade de produto existente" do
      product = Product.create!(name: "Produto X", price: 5.0)
      post "/api/cart/add_item", params: { product_id: product.id, quantity: 1 }
      post "/api/cart/add_item", params: { product_id: product.id, quantity: 1 }

      json = JSON.parse(response.body)
      expect(json["products"].first["quantity"]).to eq(2)
    end
  end

  describe "DELETE /api/cart/:product_id" do
    it "remove o item" do
      product = Product.create!(name: "Produto Y", price: 3.0)
      post "/api/cart/add_item", params: { product_id: product.id, quantity: 1 }
      delete "/api/cart/#{product.id}"

      json = JSON.parse(response.body)
      expect(json["products"]).to be_empty
    end
  end
end
