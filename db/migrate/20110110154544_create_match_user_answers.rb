class CreateMatchUserAnswers < ActiveRecord::Migration
  def self.up
    create_table :match_user_answers do |t|
      t.integer :match_user_id
      t.integer :match_question_id
      t.text :answer

      t.timestamps
    end
  end

  def self.down
    drop_table :match_user_answers
  end
end
