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
      transaction_quantity = transfer_params([:quantity])
      user_balance = current_user.balance - transaction_quantity
      if (user_balance > 0) 
        @transfer = current_user.sent_transfers.create(transfer_params)
        if @transfer.save
          redirect_to @transfer, notice: 'Transfer was successfully created.'
        else
          render :new
        end
      else
        redirect_to @transfer, notice: 'Transfer unsuccessful. Insufficient funds.'
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
  end
end
