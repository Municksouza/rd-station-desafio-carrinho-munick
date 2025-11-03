module Api
  class CartsController < ApplicationController
    include ActionController::Cookies

    # GET /api/cart
    def show
      session[:cart] ||= { "products" => [], "total_price" => 0 }
      cart = session[:cart]
      cart["total_price"] = cart["total_price"].to_f
      cart["products"].each { |p| p["total_price"] = p["total_price"].to_f }
      render json: cart

    rescue => e
      render json: { error: e.message, backtrace: e.backtrace.take(3) }, status: :internal_server_error
    end

   # POST /api/cart/add_item
    def add_item
      product = Product.find(params[:product_id])
      quantity_change = params[:quantity].to_i

      session[:cart] ||= { "products" => [], "total_price" => 0 }
      cart = session[:cart]

      item = cart["products"].find { |p| p["id"] == product.id }

      if item
        # Atualiza a quantidade (pode aumentar ou diminuir)
        item["quantity"] += quantity_change
        if item["quantity"] <= 0
          cart["products"].delete(item)
        else
          item["total_price"] = item["quantity"] * product.price
        end
      else
        # Só adiciona se for positivo
        return render json: { error: "Quantidade inválida" }, status: :unprocessable_entity if quantity_change <= 0

        cart["products"] << {
          "id" => product.id,
          "name" => product.name,
          "quantity" => quantity_change,
          "unit_price" => product.price,
          "total_price" => product.price * quantity_change
        }
      end

      cart["total_price"] = cart["products"].sum { |p| p["total_price"] }
      session[:cart] = cart
      render json: cart
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Produto não encontrado" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end


    # DELETE /api/cart/:id
    def destroy_item
      session[:cart] ||= { "products" => [], "total_price" => 0 }
      cart = session[:cart]

      item = cart["products"].find { |p| p["id"] == params[:id].to_i }

      if item
        cart["products"].delete(item)
        cart["total_price"] = cart["products"].sum { |p| p["total_price"] }
        session[:cart] = cart
        render json: cart, status: :ok
      else
        render json: { error: "Item not found" }, status: :not_found
      end
    end
  end
end