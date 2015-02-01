class AddWifToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :wif, :string
  end
end
