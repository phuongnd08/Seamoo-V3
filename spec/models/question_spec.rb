require 'spec_helper'

describe Question do
  describe "relationship" do
    it {should belong_to(:subject)}
    it {should belong_to(:creator)}
    it {should belong_to(:data)}
  end

  describe "create multiple choice question" do
    it "should successfully retains information" do
      q = Question.create_multiple_choices("Who are you", {"a" => false, "b" => false, "c" => false, "d" => true})
      data = q.reload.data
      data.content.should == "Who are you"
      data.options.sort {|o1, o2| o1.content <=> o2.content}.map{|o|[o.content, o.correct]}.should == [["a", false], ["b", false], ["c", false], ["d", true]]
    end
  end

  describe "create follow pattern question" do
    it "should successfully retains information" do
      q = Question.create_follow_pattern("Your name", "ph[uong]")
      data = q.reload.data
      data.instruction.should == "Your name"
      data.pattern.should == "ph[uong]"
    end
  end
end