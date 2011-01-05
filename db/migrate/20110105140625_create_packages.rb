class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :path
      t.text :entries
      t.boolean :done

      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
