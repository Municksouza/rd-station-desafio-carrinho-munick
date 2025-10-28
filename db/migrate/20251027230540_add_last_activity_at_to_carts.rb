class AddLastActivityAtToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :last_activity_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_index  :carts, :last_activity_at
  end
end
