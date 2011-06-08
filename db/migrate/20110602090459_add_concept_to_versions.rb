class AddConceptToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :concept, :string
  end

  def self.down
    remove_column :versions, :concept
  end
end
