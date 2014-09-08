class AddRecipientIdToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :recipient_id, :integer
  end
end
