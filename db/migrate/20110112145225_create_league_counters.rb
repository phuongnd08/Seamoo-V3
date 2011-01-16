class CreateLeagueCounters < ActiveRecord::Migration
  def self.up
    create_table :league_counters do |t|
      t.integer :league_id
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :league_counters
  end
end
