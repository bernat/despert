class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :tasks, ["task_list_id"]
    add_index :task_lists, ["project_id"]
  end

  def self.down
    remove_index :task_lists, :column => ["project_id"]
    remove_index :tasks, :column => ["task_list_id"]
  end
end
