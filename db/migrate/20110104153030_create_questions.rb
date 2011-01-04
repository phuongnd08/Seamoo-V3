class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :subject_id
      t.integer :creator_id
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
