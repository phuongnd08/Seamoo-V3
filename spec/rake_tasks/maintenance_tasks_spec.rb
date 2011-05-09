require 'spec_helper'
require 'rake'

describe "maintenance tasks" do
  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "tasks/maintenance"
    Rake::Task.define_task(:environment)
  end

  describe "schedule task" do
    it "should create new maintenance schedule" do
      now = Time.zone.now
      Time.zone.stub(:now).and_return(now)
      @rake["maintenance:schedule"].invoke
      MaintenanceSchedule.next.should_not be_nil
      MaintenanceSchedule.next.started_at.to_i.should == (now + 30.minutes).to_i
      MaintenanceSchedule.next.ended_at.to_i.should == (now + 45.minutes).to_i
    end
  end

  describe "stop task" do
    it "should update to reflect that last schedule maintenance finished" do
      now = Time.zone.now
      Time.zone.stub(:now).and_return(now)
      @rake["maintenance:schedule"].invoke
      @rake["maintenance:stop"].invoke
      MaintenanceSchedule.next.should be_nil
    end
  end

  after(:each) do
    Rake.application = nil
  end
end
