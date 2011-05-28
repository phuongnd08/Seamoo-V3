require 'spec_helper'

describe FillInTheBlanksController do

  before(:each) do
    @question = Question.create_fill_in_the_blank("Your name is {ph[uo]ng}")
    @fill_in_the_blank = @question.data
  end

  describe "GET show" do
    it "assigns the requested fill_in_the_blank as @fill_in_the_blank" do
      get :show, :id => @fill_in_the_blank
      assigns(:fill_in_the_blank).should == @fill_in_the_blank
    end

    it "should require mathjax" do
      get :show, :id => @fill_in_the_blank.id
      assigns(:use_formulae).should be_true
    end
  end

  describe "GET new" do
    it "assigns a new fill_in_the_blank as @fill_in_the_blank" do
      get :new
      assigns(:fill_in_the_blank).should be_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested fill_in_the_blank as @fill_in_the_blank" do
      get :edit, :id => @fill_in_the_blank.id
      assigns(:fill_in_the_blank).should == @fill_in_the_blank
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "should create new question" do
        lambda{
          post :create, :fill_in_the_blank => {'content' => 'Content'}
        }.should change(Question, :count).by(1)
      end

      it "redirects to the created question" do
        post :create, :fill_in_the_blank => {'content' => 'Content'}
        response.should redirect_to(FillInTheBlank.find_by_content('Content'))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @fill_in_the_blank = mock_model(FillInTheBlank)
        @fill_in_the_blank.stub(:save => false)
        FillInTheBlank.stub(:new).with({'these' => 'params'}) { @fill_in_the_blank }
      end

      it "assigns a newly created but unsaved fill_in_the_blank as @fill_in_the_blank" do
        post :create, :fill_in_the_blank => {'these' => 'params'}
        assigns(:fill_in_the_blank).should be(@fill_in_the_blank)
      end

      it "re-renders the 'new' template" do
        post :create, :fill_in_the_blank => {'these' => 'params'}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do
    before(:each) do
      FillInTheBlank.should_receive(:find).with(@fill_in_the_blank.id) { @fill_in_the_blank}
    end
    
    describe "with valid params" do
      it "updates the requested multiple_choice" do
        @fill_in_the_blank.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @fill_in_the_blank.id, :fill_in_the_blank => {'these' => 'params'}
      end

      it "redirects to the question" do
        put :update, :id => @fill_in_the_blank.id
        response.should redirect_to(@fill_in_the_blank)
      end
    end

    describe "with invalid params" do
      before(:each) do
        @fill_in_the_blank.stub(:update_attributes => false)
      end
      it "assigns the fill_in_the_blank as @fill_in_the_blank" do
        put :update, :id => @fill_in_the_blank.id
        assigns(:fill_in_the_blank).should == @fill_in_the_blank
      end

      it "re-renders the 'edit' template" do
        put :update, :id => @fill_in_the_blank.id
        response.should render_template("edit")
      end
    end
  end
end
