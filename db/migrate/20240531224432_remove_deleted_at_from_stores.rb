class RemoveDeletedAtFromStores < ActiveRecord::Migration[7.1]
  def change
    remove_column :stores, :deleted_at, :datetime
  end
end
