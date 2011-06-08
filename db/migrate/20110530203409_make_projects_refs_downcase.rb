class MakeProjectsRefsDowncase < ActiveRecord::Migration
  def self.up
    Project.all.each do |x|
      x[:ref] = x[:ref].downcase
      x.save(:validate => false)
    end
  end

  def self.down
  end
end
