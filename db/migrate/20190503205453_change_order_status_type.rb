class ChangeOrderStatusType < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :status, 'boolean USING CAST(status AS boolean)'
  end
end
