class AddStatusToLeagues < ActiveRecord::Migration
  def self.up
    add_column :leagues, :status, :string, :default => 'active'
  end

  def self.down
    remove_column :leagues, :status
  end
end
