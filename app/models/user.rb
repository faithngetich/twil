class User < ApplicationRecord
  include Clearance::User

  enum authy_status: [:onetouch, :approved, :denied, :sms]

end
