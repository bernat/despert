class AddClosedToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :closed, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :closed
  end
end
