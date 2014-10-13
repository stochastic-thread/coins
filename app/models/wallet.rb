class Wallet < ActiveRecord::Base
	belongs_to :owner,
						 :class_name => "User",
						 :primary_key => "owner_id"

end
