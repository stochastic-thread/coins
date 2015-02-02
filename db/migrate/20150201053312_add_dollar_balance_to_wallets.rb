class AddDollarBalanceToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :dollar_balance, :integer
  end
end
