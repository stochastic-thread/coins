require 'json'
require 'open-uri'

class CustomSessionsController < Devise::SessionsController
  #before_filter :before_login, :only => :create
  after_filter :after_login, :only => :create

  #def before_login
  #end

  def after_login
  	url = "https://bitcoin.toshi.io/api/v0/addresses/"
		url += current_user.wallet.receiving_address
		
  	@data = URI.parse(url).read
		hash_data = JSON.parse(@data)
		balance = hash_data['balance'].to_i + hash_data['unconfirmed_received'].to_i
  	current_user.wallet.balance = balance
  	
		current_user.wallet.save()
		current_user.save()
  	
  	urlX = "https://api.coindesk.com/v1/bpi/currentprice.json"
    @data = URI.parse(urlX).read
  	dollar = JSON.parse(@data)["bpi"]["USD"]["rate"].to_f
  	balance = current_user.wallet.balance
  	dollar_balance = ((balance * dollar)).fdiv(100000000)
 
		current_user.wallet.dollar_balance = dollar_balance
		current_user.wallet.save()
		current_user.save()
  end
end