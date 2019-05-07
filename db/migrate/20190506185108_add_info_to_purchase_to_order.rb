class AddInfoToPurchaseToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :cc_num, :integer
    add_column :orders, :cc_expiration, :integer
    add_column :orders, :zip_code, :integer
  end
end
