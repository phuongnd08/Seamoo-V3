class AddTypeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string
    User.connection.update_sql('UPDATE `users` SET `type` = "User"')
  end

  def self.down
    remove_column :users, :type
  end
end
