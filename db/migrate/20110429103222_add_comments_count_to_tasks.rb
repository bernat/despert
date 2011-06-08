class AddCommentsCountToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :comments_count, :integer, :default => 0, :null => false

    Task.all.each do |t|
      Task.update_counters t.id, :comments_count => t.comments.length
    end
  end

  def self.down
    remove_column :tasks, :comments_count
  end
end
