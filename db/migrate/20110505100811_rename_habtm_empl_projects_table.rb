class RenameHabtmEmplProjectsTable < ActiveRecord::Migration
  def self.up
    rename_table :employees_projects, :memberships
  end

  def self.down
    rename_table :memberships, :employees_projects
  end
end
