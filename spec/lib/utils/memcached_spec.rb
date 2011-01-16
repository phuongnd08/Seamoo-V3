require 'spec_helper'

describe Utils::Memcached do
  describe "get & set" do
    it "should manipulate item correctly" do
      Utils::Memcached.client.set("key", "abcx")
      Utils::Memcached.client.get("key").should == "abcx"
    end
  end

  describe "incr" do
    it "should perform atomic action over a key" do
      key = "memcached_spec_counter"
      Utils::Memcached.client.delete(key)
      queue = Queue.new
      threads = []
      (0..10).each do |index|
        threads << Thread.new do
          queue.enq Utils::Memcached.client.incr(key, 1, 0, 1)
        end
      end  
      threads.each{|t| t.join}
      arr = (0..queue.size-1).map{|i|queue.pop}
      arr.to_set.should == (1..11).to_set
    end
  end
end
