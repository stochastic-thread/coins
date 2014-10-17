class User < ActiveRecord::Base
  before_create :basic_wallet

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
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
end
