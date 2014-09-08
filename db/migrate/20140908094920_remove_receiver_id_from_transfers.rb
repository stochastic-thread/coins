class RemoveReceiverIdFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :receiver_id, :integer
  end
end
