# app/models/cart.rb
class Cart < ApplicationRecord
  enum status: { active: 0, abandoned: 1 }

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  before_create :set_initial_interaction_time

  def add_item!(product_id:, quantity:)
    q = quantity.to_i
    
    # Não permite adicionar item novo com quantidade <= 0
    raise ArgumentError, "quantity must be > 0" if q == 0
    
    with_lock do
      transaction do
        product = Product.find(product_id)

        item = cart_items.lock.find_or_initialize_by(product_id: product.id)
        item.unit_price ||= product.price

        current_quantity = item.quantity || 0
        new_quantity = current_quantity + q

        # Se a quantidade resultante seria <= 0, remove o item
        if new_quantity <= 0
          item.destroy! if item.persisted?
        else
          # Se está tentando adicionar item novo com quantidade negativa, não permite
          if item.new_record? && q < 0
            raise ArgumentError, "quantity must be > 0"
          end
          
          item.quantity = new_quantity
          item.total_price = item.unit_price * item.quantity
          item.save!
        end

        recalc_total!
        touch_interaction!
        self
      end
    end
  end

  def remove_product!(product_id:)
    with_lock do
      transaction do
        item = cart_items.lock.find_by(product_id: product_id)
        raise ActiveRecord::RecordNotFound, "product not in cart" unless item

        item.destroy!
        recalc_total!
        touch_interaction!
        self
      end
    end
  end

  def recalc_total!
    update!(total_price: cart_items.sum(:total_price))
  end

  def touch_interaction!
    update_columns(last_interacted_at: Time.current)
  end

  def mark_abandoned!
    return if abandoned?
    update!(status: :abandoned, abandoned_at: Time.current)
  end

  private

  def set_initial_interaction_time
    self.last_interacted_at ||= Time.current
  end
end
