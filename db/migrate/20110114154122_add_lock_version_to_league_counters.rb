class AddLockVersionToLeagueCounters < ActiveRecord::Migration
  def self.up
    add_column :league_counters, :lock_version, :integer
  end

  def self.down
    remove_column :league_counters, :lock_version
  end
end
