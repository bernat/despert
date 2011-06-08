class AddBillingDataToClient < ActiveRecord::Migration
  def self.up
    add_column :clients, :billing_name, :string
    add_column :clients, :bank_name, :string
    add_column :clients, :bank_account, :string
  end

  def self.down
    remove_column :clients, :billing_name
    remove_column :clients, :bank_name
    remove_column :clients, :bank_account
  end
end
