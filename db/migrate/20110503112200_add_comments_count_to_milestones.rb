class AddCommentsCountToMilestones < ActiveRecord::Migration
  def self.up
    add_column :milestones, :comments_count, :integer
  end

  def self.down
    remove_column :milestones, :comments_count
  end
end
