class CreateDebuggerSignals < ActiveRecord::Migration
  def self.up
    create_table :debugger_signals do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :debugger_signals
  end
end
