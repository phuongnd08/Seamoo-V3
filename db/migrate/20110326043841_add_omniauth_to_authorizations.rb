class AddOmniauthToAuthorizations < ActiveRecord::Migration
  def self.up
    add_column :authorizations, :omniauth, :text
  end

  def self.down
    remove_column :authorizations, :omniauth
  end
end
