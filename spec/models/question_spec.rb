require 'spec_helper'

describe Question do
  describe "relationship" do
    it {should belong_to(:category)}
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

  describe "destroy question" do
    describe "multiple choice data" do
      before(:each) do
        @question = Question.create_multiple_choices("Who are you", {"a" => false, "b" => false, "c" => false, "d" => true})
      end
      it "should destroy multiple choice data" do
        lambda{@question.destroy}.should change(MultipleChoice, :count).by(-1)
      end

      it "should destroy multiple choice options data" do
        lambda{@question.destroy}.should change(MultipleChoiceOption, :count).by(-4)
      end
    end

    describe "follow pattern data" do
      before(:each) do
        @question = Question.create_follow_pattern("Your name", "ph[uong]")
      end
      it "should destroy follow pattern data" do
        lambda{@question.destroy}.should change(FollowPattern, :count).by(-1)
      end
    end
  end
end