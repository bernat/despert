class RemoveEntryFromSubscriptions < ActiveRecord::Migration
  def self.up
    remove_column :subscriptions, :entry_base
  end

  def self.down
  end
end
