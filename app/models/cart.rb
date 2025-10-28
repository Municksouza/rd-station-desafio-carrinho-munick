class Cart < ApplicationRecord
  enum status: { active: 0, abandoned: 1 }

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  before_create :set_initial_interaction_time

  def set_initial_interaction_time
    self.last_interacted_at ||= Time.current
  end

  def add_item!(product_id:, quantity:)
    q = quantity.to_i
    raise ArgumentError, "quantity must be > 0" if q <= 0

    product = Product.find(product_id)
    item = cart_items.find_or_initialize_by(product_id: product.id)

    if item.new_record?
      item.unit_price  = product.price
      item.quantity    = q
    else
      item.quantity    += q
    end

    item.total_price = item.unit_price * item.quantity
    item.save!

    recalc_total!
  end

  def update_quantity!(product_id:, quantity:)
    raise ArgumentError, "quantity must be positive" unless quantity.to_i.positive?
    with_lock do
      transaction do
        item = cart_items.lock.find_by!(product_id: product_id)
        item.update!(quantity: quantity, total_price: item.unit_price * quantity)
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
    update_columns(last_interacted_at: Time.current) # sem callbacks extras
  end

  scope :inactive_since, ->(time) { where("last_interacted_at <= ?", time) }
  scope :abandoned_before, ->(time) { where(status: :abandoned).where("abandoned_at <= ?", time) }

  def mark_abandoned!
    return if abandoned?
    update!(status: :abandoned, abandoned_at: Time.current)
  end
end
