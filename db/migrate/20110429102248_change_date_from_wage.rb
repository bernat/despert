class ChangeDateFromWage < ActiveRecord::Migration
  def self.up
    change_column :wages, :issue_date, :date, :nil => false
  end

  def self.down
    change_column :wages, :issue_date, :datetime
  end
end
