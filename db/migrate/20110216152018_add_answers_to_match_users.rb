class AddAnswersToMatchUsers < ActiveRecord::Migration
  def self.up
    add_column :match_users, :answers, :text
  end

  def self.down
    remove_column :match_users, :answers
  end
end
