class AddCurrentQuestionToMatchUsers < ActiveRecord::Migration
  def self.up
    add_column :match_users, :current_question_position, :integer, :default => 0
  end

  def self.down
    remove_column :match_users, :current_question_position
  end
end
