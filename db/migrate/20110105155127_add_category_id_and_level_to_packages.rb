class AddCategoryIdAndLevelToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :category_id, :integer
    add_column :packages, :level, :integer
  end

  def self.down
    remove_column :packages, :category_id
    remove_column :packages, :level
  end
end
