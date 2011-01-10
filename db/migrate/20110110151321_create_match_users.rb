class CreateMatchUsers < ActiveRecord::Migration
  def self.up
    create_table :match_users do |t|
      t.integer :match_id
      t.integer :user_id
      t.integer :rank
      t.float :score
      t.datetime :finished_at

      t.timestamps
    end
  end

  def self.down
    drop_table :match_users
  end
end
