class DropMatchRequests < ActiveRecord::Migration
  def self.up
    drop_table :match_requests
  end

  def self.down
    create_table :match_requests do |t|
      t.integer :league_id
      t.integer :user_id
      t.integer :match_id

      t.timestamps
    end
  end
end
