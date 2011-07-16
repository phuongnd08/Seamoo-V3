class AddFormedAtToMatches < ActiveRecord::Migration
  def self.up
    add_column :matches, :formed_at, :datetime
    Match.reset_column_information
    Match.update_all("formed_at = created_at")
  end

  def self.down
    remove_column :matches, :formed_at
  end
end
