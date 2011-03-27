class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :league_id
      t.integer :user_id
      t.float :matches_score, :default => 0
      t.integer :matches_count, :default => 0
      t.float :rank_score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
