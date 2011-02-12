describe Matching do
  it "should contain constant inform of accessor" do
    Matching.requester_fresh.should == 300
    Matching.started_after.should == 600
    Matching.ended_after.should == 6000
  end
end
