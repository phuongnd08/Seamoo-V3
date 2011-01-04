class AddDataTypeAndDataIdToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :data_type, :string
    add_column :questions, :data_id, :integer
  end

  def self.down
    remove_column :questions, :data_type
    remove_column :questions, :data_id
  end
end
