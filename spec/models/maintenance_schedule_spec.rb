require 'spec_helper'

describe MaintenanceSchedule do
  describe "next" do
    it "should return nil if no maintenance_schedule there" do
      MaintenanceSchedule.next.should be_nil
    end

    it "should return next unfinished maintenace" do
      MaintenanceSchedule.create!(:started_at => 10.minutes.ago, :ended_at => Time.now + 2.minutes)
      MaintenanceSchedule.next.should_not be_nil
    end

    it "should return nil if all maintenance finished" do
      MaintenanceSchedule.create!(:started_at => 10.minutes.ago, :ended_at => 1.minutes.ago)
      MaintenanceSchedule.next.should be_nil
    end
  end
end
