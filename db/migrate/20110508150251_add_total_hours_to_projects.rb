class AddTotalHoursToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :total_hours, :float

    Project.all.each do |p|
      p.total_hours = p.calculate_total_hours
      p.save!
    end
  end

  def self.down
    remove_column :projects, :total_hours
  end
end
