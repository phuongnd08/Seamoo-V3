class CreateMultipleChoiceOptions < ActiveRecord::Migration
  def self.up
    create_table :multiple_choice_options do |t|
      t.integer :parent_id
      t.text :content
      t.boolean :correct

      t.timestamps
    end
  end

  def self.down
    drop_table :multiple_choice_options
  end
end
