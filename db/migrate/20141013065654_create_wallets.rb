class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.integer :owner_id
      t.string :receiving_address
      t.integer :balance

      t.timestamps
    end
  end
end
