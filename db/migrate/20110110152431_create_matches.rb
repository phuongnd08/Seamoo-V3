class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :league_id

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
