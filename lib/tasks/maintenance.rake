namespace :maintenance do
  desc "Schedule maintenance in next 30 minutes that lasts 15 minutes"
  task :schedule => :environment do
    MaintenanceSchedule.create(:started_at => Time.zone.now + 30.minutes, :ended_at => Time.zone.now + 45.minutes)
  end

  desc "Deactive last schedule maintenance if any"
  task :stop => :environment do
    maintenance_schedule = MaintenanceSchedule.next
    maintenance_schedule.update_attribute(:ended_at, Time.zone.now) if maintenance_schedule.present? && maintenance_schedule.ended_at > Time.zone.now
  end
end
