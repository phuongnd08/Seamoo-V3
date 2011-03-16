class RenameImageUrlToImageForLeagues < ActiveRecord::Migration
  def self.up
    rename_column :leagues, :image_url, :image
  end

  def self.down
    rename_column :leagues, :image, :image_url
  end
end
