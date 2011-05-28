class CreateFillInTheBlanks < ActiveRecord::Migration
  def self.up
    create_table :fill_in_the_blanks do |t|
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :fill_in_the_blanks
  end
end
