class AddIndexesToMatchRequests < ActiveRecord::Migration
  def self.up
    add_index :match_requests, :updated_at
    add_index :match_requests, :match_id
    add_index :match_requests, :league_id
    add_index :match_requests, :user_id
  end

  def self.down
    remove_index :match_requests, :updated_at
    remove_index :match_requests, :match_id
    remove_index :match_requests, :league_id
    remove_index :match_requests, :user_id
  end
end
