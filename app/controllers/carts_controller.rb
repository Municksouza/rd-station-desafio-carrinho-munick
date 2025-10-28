# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :load_or_create_cart!, only: [:show, :add_item, :destroy_item, :create]

  def show
    render json: cart_response(@cart)
  end

  def create
    product_id = cart_params.require(:product_id)
    quantity   = (cart_params[:quantity] || 1).to_i

    @cart.add_item!(product_id: product_id, quantity: quantity)
    render json: cart_response(@cart), status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: "product not found" }, status: :not_found
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def add_item
    product_id = cart_params.require(:product_id)
    quantity   = (cart_params[:quantity] || 1).to_i

    @cart.add_item!(product_id: product_id, quantity: quantity)
    render json: cart_response(@cart), status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "product not found" }, status: :not_found
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy_item
    product_id = params[:id]
    @cart.remove_product!(product_id: product_id)
    render json: cart_response(@cart), status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "product not in cart" }, status: :not_found
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end

  def load_or_create_cart!
    @cart = Cart.lock.find_by(id: session[:cart_id])
    unless @cart
      @cart = Cart.create!(total_price: 0)
      session[:cart_id] = @cart.id
    end
  end

  def cart_response(cart)
    items = cart.cart_items.includes(:product).map do |i|
      {
        id:          i.product_id,
        name:        i.product.name,
        quantity:    i.quantity,
        unit_price:  i.unit_price.to_f,
        total_price: i.total_price.to_f
      }
    end

    {
      id: cart.id,
      products: items,
      total_price: cart.total_price.to_f
    }
  end
end
