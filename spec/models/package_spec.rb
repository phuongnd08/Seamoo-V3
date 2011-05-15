require 'spec_helper'

describe Package do
  before(:each) do
    @category = Factory.create(:category)
    @level = 3
  end
  describe "relationship" do
    it {should belong_to(:category)}
  end
  
  describe "import" do
    it "should generate questions" do
      package = nil
      lambda{
        package = Package.create(:path => "spec/files/import_unimport.data", :category => @category, :level => @level)
        package.import
      }.should change(Question, :count).by(7)

      package.reload
      package.entries.count.should == 7
      questions = Question.find(:all, package.entries)
      questions.map{|i| i.data.class.name}.should == (["MultipleChoice"] * 3).concat(["FollowPattern"] * 2).concat(["FillInTheBlank"] * 2)
      questions[0].data.content.should == "từ thể hiện sự đồng ý"
      questions[0].data.options.inject({}){|r, o| r[o.content] = o.correct; r}
      questions[3].data.instruction.should == "'đằng sau' viết là"
      questions[3].data.pattern.should == "[b]ack"
      questions[4].data.instruction.should == "'khoảng cách' viết là"
      questions[4].data.pattern.should == "distan[ce]"
      questions[5].data.content.should == "'khoảng cách': {distance}"
      questions[6].data.content.should == "'đặt tên': {name|naming}"
      questions.map(&:category).should == [@category]*7
      questions.map(&:level).should == [@level]*7
    end
  end

  describe "unimport!" do
    it "should destroy all imported questions" do
      package = Package.create(:path => "spec/files/import_unimport.data")
      package.import
      lambda{package.unimport!}.should change(Question, :count).by(-7)
    end

    it "should delete the package" do
      package = Package.create(:path => "spec/files/import_unimport.data")
      package.import
      package.unimport!
      Package.find_by_id(package.id).should == nil
    end
  end
end
