class MaintenanceSchedule < ActiveRecord::Base
  class << self
    def next
      where(["ended_at > ?", Time.now]).first
    end
  end
end
