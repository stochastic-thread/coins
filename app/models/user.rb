class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_transfers, :class_name => "Transfer", :foreign_key => "sender_id"
  has_many :received_transfers, :class_name => "Transfer", :foreign_key => "recipient_id"

  def show_name
  	self.name.titleize
  end
end
