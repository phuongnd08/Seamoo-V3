class CreateFollowPatterns < ActiveRecord::Migration
  def self.up
    create_table :follow_patterns do |t|
      t.text :instruction
      t.string :pattern

      t.timestamps
    end
  end

  def self.down
    drop_table :follow_patterns
  end
end
