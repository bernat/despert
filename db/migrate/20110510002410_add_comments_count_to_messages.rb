class AddCommentsCountToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :comments_count, :integer
  end

  def self.down
    remove_column :messages, :comments_count
  end
end
