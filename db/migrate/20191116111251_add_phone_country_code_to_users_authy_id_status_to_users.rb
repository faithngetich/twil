class AddPhoneCountryCodeToUsersAuthyIdStatusToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :country_code, :string
    add_column :users, :authy_id, :string
    add_column :users, :authy_status, :integer, :null => false, :default => 0
  end
end
