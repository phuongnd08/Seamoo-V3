require 'spec_helper'

describe MultipleChoice do
  describe "relationship" do
    it {should have_many(:options)}
  end

  describe "update nested options" do
    it "should change items accordingly options_attributes" do
      @multiple_choice = MultipleChoice.create(:content => "What's your name")
      @multiple_choice.options_attributes = [ { :content => 'Phuong' }, { :content => 'Toan' } ]
      @multiple_choice.save
      @multiple_choice.reload.options.count.should == 2
      @multiple_choice.options_attributes = [{:id => @multiple_choice.options.first.id, '_destroy' => '1' }]
      @multiple_choice.save
      @multiple_choice.reload.options.count.should == 1
    end
  end

  describe "randomized_options" do
    it "should return options in randomized order" do
      @multiple_choice = MultipleChoice.create(:content => "What's your name")
      @multiple_choice.options_attributes = [ { :content => 'Phuong' }, { :content => 'Toan' }, {:content => 'Hung'} ]
      randomized_options = @multiple_choice.randomized_options
      randomized_options.map{|index, option| index}.to_set.should == [0, 1, 2].to_set
      randomized_options.map{|index, option| option.content}.to_set.should == [ 'Phuong', 'Toan', 'Hung'].to_set
    end
  end

  describe "score_for" do
    it "should return 1 for correct answer and 0 for incorrect answer" do
      @multiple_choice = MultipleChoice.create(:content => "What's your name")
      @multiple_choice.options_attributes = [ { :content => 'Phuong', :correct => true }, { :content => 'Toan' }, {:content => 'Hung'} ]
      @multiple_choice.score_for('0').should == 1
      @multiple_choice.score_for('1').should == 0
      @multiple_choice.score_for('2').should == 0
      @multiple_choice.score_for(nil).should == 0
    end
  end


  describe "answer" do
    it "should report multiple_choice id if error happen" do
      @multiple_choice = MultipleChoice.create(:content => "What's your name")
      HoptoadNotifier.should_receive(:notify).with do |data|
        data[:error_class].should == "MultipleChoice"
        data[:error_message].should include("Exception")
        data[:parameters].should == {:multiple_choice_id => @multiple_choice.id}
      end
      @multiple_choice.answer.should be_nil
    end
  end
end
