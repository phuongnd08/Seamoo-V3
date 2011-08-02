require 'spec_helper'

describe 'home page' do
  before(:each) do
    @math = Factory(:category, :name => "Math", :status => 'coming_soon')
    @language = Factory(:category, :name => "Language", :status => 'active')
    visit root_path
  end
  it "should show introduction" do
    page.should have_content("Competition system")
  end

  describe "category nativgation" do
    context "active league" do
      it "headers should be clickable" do
        page.should have_content("Language")
        click_on "Language"
        current_path.should == category_path(@language)
      end

      it "main links should be clickable" do
        within "#language" do
          click_on "Join now"
          current_path.should == category_path(@language)
        end
      end
    end

    context "inactive league" do
      it "headers should not be clickable" do
        page.should have_content("Math")
        page.should have_no_xpath(XPath::HTML.link("Math"))
      end

      it "there should be no mainlinks" do
        within "#math" do
          page.should have_no_content("Join now")
        end
      end
    end
  end
end
