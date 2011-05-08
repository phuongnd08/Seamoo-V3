require 'spec_helper'

describe HomeController do
  describe "get index with malformed locale" do
    it "should report wrong locale and reset to default_locale" do
      controller.should_receive(:notify_hoptoad).with do |arg|
        arg[:error_class].should == "Malform Locale"
        arg[:parameters][:locale].should == "a"
      end
      get :index, :locale => "a"
      I18n.locale.should == :en
    end
  end

  describe "get index without locale" do
    it "should set locale to default_locale" do
      get :index
      I18n.locale.should == :en
    end
  end

  describe "get index with vi locale" do
    it "should set locale to vi locale" do
      get :index, :locale => "vi"
      I18n.locale.should == :vi
    end
  end

  describe "get index with en locale" do
    it "should set locale to default_locale" do
      get :index, :locale => "en"
      I18n.locale.should == :en
    end
  end
end
