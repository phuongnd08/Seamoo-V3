require 'spec_helper'

describe LeagueCounter do
  describe "relationships" do
    it{should belong_to(:league)}
  end

  describe "synchronize" do
    it "should ensure operations are performed atomically" do
      counter = LeagueCounter.create(:value => 0)
      puts "=> #{LeagueCounter.connection.object_id}"
      threads = []
      (0..2).each do |index|
        threads << Thread.new do
          puts "#{index} => #{LeagueCounter.connection.object_id}\n"
          LeagueCounter.synchronize(counter.id) do |c|
            sleep rand
            c.value +=1
            c.save
          end
        end
      end
      threads.each{|t| t.join}
      counter.reload.value.should == 3
    end
  end
end
