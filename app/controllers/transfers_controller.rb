require 'chain'
require 'curb'

class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]

  # GET /transfers
  # GET /transfers.json
  def index
    @transfers = Transfer.all
  end

  # GET /transfers/1
  # GET /transfers/1.json
  def show
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
  end

  # GET /transfers/1/edit
  def edit
  end

  # POST /transfers
  # POST /transfers.json
  def create
    @transfer = current_user.sent_transfers.create(transfer_params)
    if current_user
      transaction_quantity = params[:transfer][:quantity]
      user_balance = current_user.wallet.balance
      if (user_balance > transaction_quantity.to_i + 10000) 
        build_tx()
        if @transfer.save
          redirect_to @transfer, notice: 'Transfer was successfully created.'
        else
          render :new
        end
      elsif (user_balance < transaction_quantity.to_i + 10000)
        redirect_to @transfer, notice: 'Transfer unsuccessful. Insufficient funds.'
      elsif (user_balance == 0) 
        redirect_to @transfer, notice: 'Transfer unsuccessful. You have no money.'
      end
    end
  end

  # PATCH/PUT /transfers/1
  # PATCH/PUT /transfers/1.json
  def update
    if @transfer.update(transfer_params)
      redirect_to @transfer, notice: 'Transfer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /transfers/1
  # DELETE /transfers/1.json
  def destroy
    @transfer.destroy
    redirect_to transfers_url, notice: 'Transfer was successfully destroyed.'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transfer_params
    params.require(:transfer).permit(:quantity, :recipient_id)
  end

  def build_tx
    chain_client = Chain::Client.new(key_id: '59445ce9f6dd4f663e95f42cd99156cf', key_secret: 'ad1aa3b249c60b4a2bc97208c4d35e14')
    str = chain_client.transact(  
      inputs: [
        {
          address: current_user.wallet.receiving_address,
          private_key: current_user.wallet.wif
        }
      ],
      outputs: [
        {
          address: User.find(params[:transfer][:recipient_id]).wallet.receiving_address,
          amount: params[:transfer][:quantity]
        }
      ]
    )
    update_balance(params[:transfer][:quantity] - 10000)
    puts str
  end

  def update_balance(quantity)
    url = "https://bitcoin.toshi.io/api/v0/addresses/"
    url += current_user.wallet.receiving_address
    @data = Curl.get(url).body_str
    hash_data = JSON.parse(@data)
    balance = hash_data['balance'].to_i + hash_data['unconfirmed_received'].to_i
    current_user.wallet.balance = balance
    current_user.wallet.save()
    url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    balance = current_user.wallet.balance
    @data = Curl.get(url).body_str
    dollar = JSON.parse(@data)["bpi"]["USD"]["rate"].to_f
    dollar_balance = ((balance * dollar)).fdiv(100000000)
    current_user.wallet.balance = balance
    current_user.wallet.dollar_balance = dollar_balance
    current_user.wallet.save()
    current_user.save()
  end

  private :set_transfer, :transfer_params, :build_tx, :update_balance
end
