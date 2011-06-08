class AddVariablePartToEmployees < ActiveRecord::Migration
  def self.up
    add_column :users, :variable_part, :float, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :variable_part
  end
end
