require 'spec_helper'

describe Utils::Memcached, :memcached => true do
  before(:each) do
    @client = Utils::Memcached::Common.client
  end
  describe "Common" do
    describe "client" do
      describe "get & set" do
        it "should manipulate string correctly" do
          @client.set("key", "abcx")
          @client.get("key").should == "abcx"
        end

        it "should manipulate object correctly" do
          @client.set("key", {:a => 100, :b => :c})
          @client.get("key").should == {:a => 100, :b => :c}
        end
      end

      describe "incr" do
        it "should perform atomic action over a key" do
          key = "memcached_spec_counter"
          @client.delete(key)
          queue = Queue.new
          threads = []
          (0..10).each do |index|
            threads << Thread.new do
              queue.enq @client.incr(key, 1, 0, 1)
            end
          end  
          threads.each{|t| t.join}
          arr = (0..queue.size-1).map{|i|queue.pop}
          arr.to_set.should == (1..11).to_set
        end
      end

      describe "flush" do
        it "should wipe out all memcached data" do
          key = "test_reset_key"
          @client.set(key, 100)
          @client.flush
          @client.get(key).should == nil
        end
      end
    end

    describe "hash_to_key" do
      it "should return key that concat hash key & value" do
        (0..10).each do |index|
          Utils::Memcached::Common.hash_to_key({:category => "abc", :id => 123, :league_id => 1234}).should == "category@abc_id@123_league_id@1234"
        end
      end
    end
  end

  describe "Hash" do
    before(:each) do
      @hash = Utils::Memcached::MemHash.new({:category => "random", :id => "1"})
      @client.flush_all
    end

    describe "getter && setter" do
      it "should correctly manipulate data" do
        @hash[{:name => "abc"}] = "xyz"
        @hash[{:name => "abc"}].should == "xyz"
      end
    end

    describe "incr" do
      it "should increase key sequencially" do
        @hash.incr({:name => "counter"}).should == 1
        @hash.incr({:name => "counter"}).should == 2
        @hash.incr({:name => "counter"}).should == 3
      end
    end
  end
end
