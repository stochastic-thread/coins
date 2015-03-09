class User < ActiveRecord::Base
  before_create :basic_wallet

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Stripe::Callbacks
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_transfers,
           :class_name => "Transfer",
           :foreign_key => "sender_id"

  has_many :received_transfers,
           :class_name => "Transfer",
           :foreign_key => "recipient_id"

  has_one :wallet,
          :class_name => "Wallet",
          :foreign_key => "owner_id"

  def show_name
  	self.name.titleize
  end

  def basic_wallet
    self.wallet = Wallet.create(:owner_id => self.id)
  end

  def do_deposit_transaction(amount, stripe_token)
    amount = Transaction.amount_for_type(amount)
    coupon = UserCoupon.coupon_for_amount(amount)
    card = save_credit_card(stripe_token) 
    if deposited = deposit(amount, card) 
      subscribe if type == 'subscription' 
      create_coupon(coupon) if coupon
      deposited 
    end 
  end

  def deposit(amount, card)
    customer = stripe_customer

    Stripe::Charge.create(
      amount: amount,
      currency: 'usd',
      customer: customer.id,
      card: card.id,
      description: "Charge for #{email}"
    )
    customer.account_balance += amount
    customer.save 
  end
end
