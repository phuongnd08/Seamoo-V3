class AddRecordedToMatchUsers < ActiveRecord::Migration
  def self.up
    add_column :match_users, :recorded, :boolean, :default => false
  end

  def self.down
    remove_column :match_users, :recorded
  end
end
