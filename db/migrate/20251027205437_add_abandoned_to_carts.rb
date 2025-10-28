class AddAbandonedToCarts < ActiveRecord::Migration[7.1]
  def change
    # evita duplicar se a coluna já existir
    add_column :carts, :abandoned, :boolean, default: false, null: false unless column_exists?(:carts, :abandoned)
    add_column :carts, :last_interaction_at, :datetime unless column_exists?(:carts, :last_interaction_at)
  end
end
