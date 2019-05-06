class ChangeExpDatetoOrderasDate < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :zip_code, :string
    add_column :orders, :cc_cvv, :string
  end
end
