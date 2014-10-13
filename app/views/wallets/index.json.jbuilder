json.array!(@wallets) do |wallet|
  json.extract! wallet, :id, :owner_id, :receiving_address, :balance
  json.url wallet_url(wallet, format: :json)
end
