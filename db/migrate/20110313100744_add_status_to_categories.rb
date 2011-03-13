class AddStatusToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :status, :string, :default => "active"
  end

  def self.down
    add_column :categories, :status
  end
end
