class AddUseFormulaeToLeagues < ActiveRecord::Migration
  def self.up
    add_column :leagues, :use_formulae, :boolean, :default => false
  end

  def self.down
    remove_column :leagues, :use_formulae
  end
end
