class AddUnitPriceCentsToCartItems < ActiveRecord::Migration[7.1]
  def up
    add_column :cart_items, :unit_price_cents, :integer

    if column_exists?(:cart_items, :unit_price)
      execute <<~SQL
        UPDATE cart_items
        SET unit_price_cents = ROUND(unit_price * 100)
        WHERE unit_price IS NOT NULL;
      SQL
    end

    change_column_null :cart_items, :unit_price_cents, true
  end

  def down
    remove_column :cart_items, :unit_price_cents
  end
end
