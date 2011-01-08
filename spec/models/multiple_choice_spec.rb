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
end
