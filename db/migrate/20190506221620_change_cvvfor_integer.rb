class ChangeCvvforInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_cvv, :integer, using: "cc_cvv::integer"
  end
end
