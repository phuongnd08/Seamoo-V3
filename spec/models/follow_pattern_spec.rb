require 'spec_helper'

describe FollowPattern do
  shared_examples_for "follow pattern question" do
    describe "hint" do
      it "should substitute desired input with asterisk but do not substitute space" do
        fp.hint.should == hint
      end
    end

    describe "answer" do
      it "should return pattern without the markup" do
        fp.answer.should == answer
      end
    end

    describe "score_for" do
      it "should return 1 for correct answer without regarding to case" do
        correct_ans.each do |ans|
          fp.score_for(ans).should == 1
        end
      end

      it "should return 0 for incorrect answer" do
        incorrect_ans.each do |ans|
          fp.score_for(ans).should == 0
        end
      end
    end

    describe "preview" do
      it "should return instruction" do
        fp.preview.should == "Instruction"
      end
    end
  end

  describe "m[y] ans[wer]" do
    let(:fp){ FollowPattern.new(:instruction => "Instruction", :pattern => "m[y] ans[wer]") }
    let(:hint){"*y ***wer"}
    let(:answer){"my answer"}
    let(:correct_ans){["my answer", "MY ANSWEr"]}
    let(:incorrect_ans){["my awer", nil]}
    it_should_behave_like "follow pattern question"
  end

  describe "m[y] ans[wer]" do
    let(:fp){ FollowPattern.new(:instruction => "Instruction", :pattern => "[g]o [b]ack") }
    let(:hint){"g* b***"}
    let(:answer){"go back"}
    let(:correct_ans){["go back", "gO Back"]}
    let(:incorrect_ans){["goback", nil]}
    it_should_behave_like "follow pattern question"
  end
end
