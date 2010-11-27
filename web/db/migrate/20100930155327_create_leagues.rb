class CreateLeagues < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.integer :category_id
      t.string :alias
      t.string :name
      t.string :description
      t.string :image_url
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :leagues
  end
end
