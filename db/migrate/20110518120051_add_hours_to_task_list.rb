class AddHoursToTaskList < ActiveRecord::Migration
  def self.up
    add_column :task_lists, :hours, :float
    add_column :task_lists, :description, :text
  end

  def self.down
    remove_column :task_lists, :description
    remove_column :task_lists, :hours
  end
end
