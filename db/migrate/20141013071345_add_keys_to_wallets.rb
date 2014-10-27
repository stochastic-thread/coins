class AddKeysToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :private_key, :string
    add_column :wallets, :public_key, :string
  end
end
