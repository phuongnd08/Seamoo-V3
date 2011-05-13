require 'spec_helper'

describe "Maintenance schedule", :js => true do
  it "should show maintenance schedule if there is" do
    time_from = Time.now + 2.minutes
    time_to = Time.now + 4.minutes
    MaintenanceSchedule.create(:started_at => time_from, :ended_at => time_to) 
    visit root_path
    time_from_s = time_from.strftime("%Y/%m/%d %H:%M")
    time_to_s = time_to.strftime("%Y/%m/%d %H:%M")
    page.find(:css, '#maintenance_schedule').text.should == "System will be down from #{time_from_s} to #{time_to_s} for maintenance"
  end
end
