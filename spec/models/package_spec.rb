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
      }.should change(Question, :count).by(6)

      package.reload
      package.entries.count.should == 6
      questions = Question.find(:all, package.entries)
      questions.map{|i| i.data.class.name}.should == (["MultipleChoice"] * 2).concat(["FollowPattern"] * 2).concat(["FillInTheBlank"] * 2)
      questions[0].data.content.should == %{từ thể hiện sự đồng ý <img src="http://host.com/img1.jpg"/>}
      questions[0].data.options.inject({}){|r, o| r[o.content] = o.correct; r}.should == {
        "yes" => true,
        "no" => false,
        "never" => false,
        "always" => false
      }
      questions[1].data.options.inject({}){|r, o| r[o.content] = o.correct; r}.should == {
        "no" => true,
        %{now <img src="http://host.com/img2.jpg"/>} => false,
        "never" => false,
        "how" => false
      }
      questions[2].data.instruction.should == "'đằng sau' viết là"
      questions[2].data.pattern.should == "[b]ack"
      questions[3].data.instruction.should == %{'khoảng cách' viết là <img src="http://host.com/img3.jpg"/>}
      questions[3].data.pattern.should == "distan[ce]"
      questions[4].data.content.should == %{'khoảng cách' <img src="http://host.com/img4.jpg"/>: {distance}}
      questions[5].data.content.should == "'đặt tên': {name|naming}"
      questions.each do |q|
        q.category.should == @category
        q.level.should == @level
      end
    end
  end

  describe "unimport!" do
    it "should destroy all imported questions" do
      package = Package.create(:path => "spec/files/import_unimport.data")
      package.import
      lambda{package.unimport!}.should change(Question, :count).by(-6)
    end

    it "should delete the package" do
      package = Package.create(:path => "spec/files/import_unimport.data")
      package.import
      package.unimport!
      Package.find_by_id(package.id).should == nil
    end
  end
end
