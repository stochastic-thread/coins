class Wallet < ActiveRecord::Base
  before_create :keypair

	belongs_to :owner,
						 :class_name => "User",
						 :primary_key => "owner_id"

  def keypair
    key = Bitcoin::generate_key
    privkey = key[0]
    pubkey = key[1]
    self.private_key = privkey
    self.public_key = pubkey
    addr = Bitcoin::pubkey_to_address(pubkey)
    self.receiving_address = addr
  end
end
