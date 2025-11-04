require 'rails_helper'

RSpec.describe "Products API", type: :request do
  let!(:product) { Product.create!(name: "Produto 1", price: 12.5) }

  describe "GET /api/products" do
    it "renders a successful response" do
      get "/api/products"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /api/products/:id" do
    it "renders a successful response" do
      get "/api/products/#{product.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/products" do
    it "creates a new Product" do
      expect {
        post "/api/products", params: { product: { name: "Novo", price: 9.99 } }
      }.to change(Product, :count).by(1)
    end
  end

  describe "PATCH /api/products/:id" do
    it "updates the requested product" do
      patch "/api/products/#{product.id}", params: { product: { name: "Atualizado" } }
      expect(response).to have_http_status(:success)
      expect(Product.find(product.id).name).to eq("Atualizado")
    end
  end

  describe "DELETE /api/products/:id" do
    it "destroys the requested product" do
      expect {
        delete "/api/products/#{product.id}"
      }.to change(Product, :count).by(-1)
    end
  end
end
