# spec/requests/carts_spec.rb
require "rails_helper"

RSpec.describe "Carts API", type: :request do
  let!(:product) { create(:product, price: 7.0) }

  it "POST /cart cria carrinho na sessão e adiciona item" do
    post "/cart", params: { product_id: product.id, quantity: 2 }.to_json,
                  headers: { "CONTENT_TYPE" => "application/json" }
    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body["products"].first["quantity"]).to eq(2)
    expect(body["total_price"]).to eq(14.0)
  end

  it "GET /cart lista itens do carrinho" do
    post "/cart", params: { product_id: product.id, quantity: 1 }.to_json,
                  headers: { "CONTENT_TYPE" => "application/json" }
    get "/cart"
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["products"].first["id"]).to eq(product.id)
  end

  it "POST /cart/add_item altera quantidade de produto existente" do
    post "/cart", params: { product_id: product.id, quantity: 1 }.to_json,
                  headers: { "CONTENT_TYPE" => "application/json" }
    post "/cart/add_item", params: { product_id: product.id, quantity: 2 }.to_json,
                           headers: { "CONTENT_TYPE" => "application/json" }
    body = JSON.parse(response.body)
    expect(body["products"].first["quantity"]).to eq(3)
    expect(body["total_price"]).to eq(21.0)
  end

  it "DELETE /cart/:product_id remove o item" do
    post "/cart", params: { product_id: product.id, quantity: 2 }.to_json,
                  headers: { "CONTENT_TYPE" => "application/json" }
    delete "/cart/#{product.id}"
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["products"]).to be_empty
    expect(body["total_price"]).to eq(0.0)
  end
end
