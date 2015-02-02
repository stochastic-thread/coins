class AddPrevTxToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :prevtx, :string
  end
end
