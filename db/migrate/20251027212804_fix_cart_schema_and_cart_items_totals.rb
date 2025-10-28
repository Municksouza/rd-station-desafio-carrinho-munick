# db/migrate/20251027120000_fix_cart_schema_and_cart_items_totals.rb
class FixCartSchemaAndCartItemsTotals < ActiveRecord::Migration[7.1]
  def up
    
    change_table :carts do |t|
      t.integer  :status, default: 0, null: false unless column_exists?(:carts, :status)
      t.datetime :last_interacted_at            unless column_exists?(:carts, :last_interacted_at)
      t.datetime :abandoned_at                  unless column_exists?(:carts, :abandoned_at)
    end

    if column_exists?(:carts, :last_interaction_at) && !column_exists?(:carts, :last_interacted_at)
      rename_column :carts, :last_interaction_at, :last_interacted_at
    end

    remove_column :carts, :abandoned, :boolean if column_exists?(:carts, :abandoned)

    if column_exists?(:carts, :total_price)
      change_column_default :carts, :total_price, from: nil, to: 0.0
      change_column_null    :carts, :total_price, false, 0.0
      change_column :carts, :total_price, :decimal, precision: 17, scale: 2, using: "total_price::decimal"
    else
      add_column :carts, :total_price, :decimal, precision: 17, scale: 2, null: false, default: 0.0
    end

    if column_exists?(:cart_items, :unit_price)
      change_column :cart_items, :unit_price, :decimal, precision: 17, scale: 2, using: "unit_price::decimal"
    else
      add_column :cart_items, :unit_price, :decimal, precision: 17, scale: 2, null: false, default: 0.0
    end

    unless column_exists?(:cart_items, :total_price)
      add_column :cart_items, :total_price, :decimal, precision: 17, scale: 2, null: false, default: 0.0
    end

    remove_column :cart_items, :unit_price_cents, :integer if column_exists?(:cart_items, :unit_price_cents)

    if column_exists?(:products, :price)
      change_column :products, :price, :decimal, precision: 17, scale: 2, using: "price::decimal"
      change_column_null    :products, :price, false
      change_column_default :products, :price, from: nil, to: 0.0
    else
      add_column :products, :price, :decimal, precision: 17, scale: 2, null: false, default: 0.0
    end
  end

  def down
  end
end
