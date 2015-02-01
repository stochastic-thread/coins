class Wallet < ActiveRecord::Base
  before_create :keypair

	belongs_to :owner,
						 :class_name => "User",
						 :primary_key => "owner_id"

  def keypair
    key = Bitcoin::Key.generate
    privkey = key.priv()
    pubkey = key.pub()
    self.wif = key.to_base58
    self.private_key = privkey
    self.public_key = pubkey
    addr = Bitcoin::pubkey_to_address(pubkey)
    self.receiving_address = addr
  end
end
