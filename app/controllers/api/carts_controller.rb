# app/controllers/api/carts_controller.rb
module Api
  class CartsController < ApplicationController
    include ActionController::Cookies

    before_action :load_cart

    # GET /api/cart
    def show
      cart = @cart
      return render json: empty_payload, status: :ok unless cart

      render json: payload(cart), status: :ok
    end

    # POST /api/cart  { product_id, quantity }
    def create
      cart = @cart || create_cart_for_session!

      cart.add_item!(product_id: params[:product_id], quantity: params[:quantity])
      render json: payload(cart), status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Produto não encontrado" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end

    # POST /api/cart/add_item  { product_id, quantity }
    # IMPORTANTE: se não existir carrinho na sessão, cria (pra bater com o spec)
    # E este endpoint, pelo spec do seu log, está sendo usado como "adicionar"
    def add_item
      cart = @cart || create_cart_for_session!

      cart.add_item!(product_id: params[:product_id], quantity: params[:quantity])
      render json: payload(cart), status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Produto não encontrado" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end

    # DELETE /api/cart/:id  (o spec passa id, não product_id)
    def destroy_item
      cart = @cart || create_cart_for_session!

      cart.remove_product!(product_id: params[:id])
      render json: payload(cart), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Produto não encontrado no carrinho" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def load_cart
      return unless session[:cart_id]
      @cart = Cart.find_by(id: session[:cart_id])
    end

    def create_cart_for_session!
      cart = Cart.create!(status: :active, total_price: 0.0)
      session[:cart_id] = cart.id
      cart
    end

    def payload(cart)
      {
        "id" => cart.id,
        "products" => cart.cart_items.includes(:product).map do |item|
          {
            "id" => item.product_id,
            "name" => item.product.name,
            "quantity" => item.quantity,
            "unit_price" => item.unit_price.to_f,
            "total_price" => item.total_price.to_f
          }
        end,
        "total_price" => cart.total_price.to_f
      }
    end

    def empty_payload
      { "products" => [], "total_price" => 0.0 }
    end
  end
end
