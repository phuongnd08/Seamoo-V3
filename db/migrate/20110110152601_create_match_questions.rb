class CreateMatchQuestions < ActiveRecord::Migration
  def self.up
    create_table :match_questions do |t|
      t.integer :match_id
      t.integer :question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :match_questions
  end
end
