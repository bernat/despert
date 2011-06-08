class DropVestalVersions < ActiveRecord::Migration
  def self.up
    drop_table :versions
  end

  def self.down
  end
end
