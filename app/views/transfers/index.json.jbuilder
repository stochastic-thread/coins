json.array!(@transfers) do |transfer|
  json.extract! transfer, :id, :quantity, :sender_id, :receiver_id
  json.url transfer_url(transfer, format: :json)
end
