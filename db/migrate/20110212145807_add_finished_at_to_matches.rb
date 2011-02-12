class AddFinishedAtToMatches < ActiveRecord::Migration
  def self.up
    add_column :matches, :finished_at, :time
  end

  def self.down
    remove_column :matches, :finished_at
  end
end
