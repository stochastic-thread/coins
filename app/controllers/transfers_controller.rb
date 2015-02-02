require 'chain'

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
    if current_user
      transaction_quantity = params[:transfer][:quantity]
      user_balance = current_user.wallet.balance - transaction_quantity.to_i
      if (user_balance > 0) 
        @transfer = current_user.sent_transfers.create(transfer_params)
        if @transfer.save
          redirect_to @transfer, notice: 'Transfer was successfully created.'
        else
          render :new
        end
      elsif user_balance < transaction_quantity
        redirect_to @transfer, notice: 'Transfer unsuccessful. Insufficient funds.'
      end

      if (user_balance == 0) 
        redirect_to @transfer, notice: 'Transfer unsuccessful. You have no money.'
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_params
      params.require(:transfer).permit(:quantity, :recipient_id)
    end

    def build_tx
      chain_client.transact(  
        inputs: [
          {
            address: current_user.wallet.receiving_address,
            private_key: current_user.wallet.wif
          }
        ],
        outputs: [
          {
            address: User.find(params[:transfer][:id]),
            amount: params[:transfer][:quantity]
          }
        ]
      )
      current_user.wallet.balance = 
    end
  end
end
