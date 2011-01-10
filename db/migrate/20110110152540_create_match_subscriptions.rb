class CreateMatchSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :match_subscriptions do |t|
      t.integer :league_id
      t.integer :user_id
      t.integer :match_id

      t.timestamps
    end
  end

  def self.down
    drop_table :match_subscriptions
  end
end
