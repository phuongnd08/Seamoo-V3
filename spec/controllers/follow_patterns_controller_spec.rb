require 'spec_helper'

describe FollowPatternsController do

  before(:each) do
    @question = Question.create_follow_pattern("Your name", "ph[uo]ng")
    @follow_pattern = @question.data
  end

  describe "GET show" do
    it "assigns the requested follow_pattern as @follow_pattern" do
      get :show, :id => @follow_pattern
      assigns(:follow_pattern).should == @follow_pattern
    end

    it "should require mathjax" do
      get :show, :id => @follow_pattern.id
      assigns(:use_formulae).should be_true
    end
  end

  describe "GET new" do
    it "assigns a new follow_pattern as @follow_pattern" do
      get :new
      assigns(:follow_pattern).should be_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested follow_pattern as @follow_pattern" do
      get :edit, :id => @follow_pattern.id
      assigns(:follow_pattern).should == @follow_pattern
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "should create new question" do
        lambda{
          post :create, :follow_pattern => {'instruction' => 'Content', 'pattern' => 'co[nten]t'}
        }.should change(Question, :count).by(1)
      end

      it "redirects to the created question" do
        post :create, :follow_pattern => {'instruction' => 'Content'}
        response.should redirect_to(FollowPattern.find_by_instruction('Content'))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @follow_pattern = mock_model(MultipleChoice)
        @follow_pattern.stub(:save => false)
        FollowPattern.stub(:new).with({'these' => 'params'}) { @follow_pattern }
      end

      it "assigns a newly created but unsaved follow_pattern as @follow_pattern" do
        post :create, :follow_pattern => {'these' => 'params'}
        assigns(:follow_pattern).should be(@follow_pattern)
      end

      it "re-renders the 'new' template" do
        post :create, :follow_pattern => {'these' => 'params'}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do
    before(:each) do
      FollowPattern.should_receive(:find).with(@follow_pattern.id) { @follow_pattern}
    end
    
    describe "with valid params" do
      it "updates the requested multiple_choice" do
        @follow_pattern.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @follow_pattern.id, :follow_pattern => {'these' => 'params'}
      end

      it "redirects to the question" do
        put :update, :id => @follow_pattern.id
        response.should redirect_to(@follow_pattern)
      end
    end

    describe "with invalid params" do
      before(:each) do
        @follow_pattern.stub(:update_attributes => false)
      end
      it "assigns the follow_pattern as @follow_pattern" do
        put :update, :id => @follow_pattern.id
        assigns(:follow_pattern).should == @follow_pattern
      end

      it "re-renders the 'edit' template" do
        put :update, :id => @follow_pattern.id
        response.should render_template("edit")
      end
    end
  end
end
