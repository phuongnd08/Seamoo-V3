class AddCategoryIdAndRemoveSubjectIdFromQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :category_id, :integer
    remove_column :questions, :subject_id
  end

  def self.down
    add_column :questions, :subject_id, :integer
    remove_column :questions, :category_id
  end
end
