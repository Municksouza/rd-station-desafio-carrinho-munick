class RemoveDefaultFromProductsPrice < ActiveRecord::Migration[7.1]
  def change
    change_column_default :products, :price, from: 0, to: nil
  end
end
