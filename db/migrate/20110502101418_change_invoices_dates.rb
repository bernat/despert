class ChangeInvoicesDates < ActiveRecord::Migration
  def self.up
    change_column :invoices, :issue_date, :date
    change_column :invoices, :payment_date, :date
  end

  def self.down
    change_column :invoices, :issue_date, :datetime
    change_column :invoices, :payment_date, :datetime
  end
end
