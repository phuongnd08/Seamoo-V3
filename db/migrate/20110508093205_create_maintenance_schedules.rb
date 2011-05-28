class CreateMaintenanceSchedules < ActiveRecord::Migration
  def self.up
    create_table :maintenance_schedules do |t|
      t.timestamp :started_at
      t.timestamp :ended_at

      t.timestamps
    end
  end

  def self.down
    drop_table :maintenance_schedules
  end
end
