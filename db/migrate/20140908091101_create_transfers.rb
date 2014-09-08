class CreateTransfers < ActiveRecord::Migration
  def change
    change_table :transfers do |t|
      t.integer :quantity
      t.integer :sender_id
      t.integer :recipient_id
      t.timestamps
    end
  end
end
