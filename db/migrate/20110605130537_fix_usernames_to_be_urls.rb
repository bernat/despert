class FixUsernamesToBeUrls < ActiveRecord::Migration
  def self.up
    Employee.all.each do |x|
      x[:username] = x[:username].downcase.to_ascii.gsub(/[^[:alnum:]]/,'-')
      x.save(:validate => false)
    end
  end

  def self.down
  end
end
