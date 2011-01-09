require 'spec_helper'

describe QuestionsController do

  render_views
  
  before(:each) do
    @multiple_choice_question = Question.create_multiple_choices("What's your name", {})
    @multiple_choice = @multiple_choice_question.data
    @follow_pattern_question = Question.create_follow_pattern("My name", '')
    @follow_pattern = @follow_pattern_question.data
  end

  describe "GET index" do
    it "assigns all questions as @questions" do
      get :index
      assigns(:questions).to_set.should == [@multiple_choice_question, @follow_pattern_question].to_set
    end
  end

  describe "GET show" do
    describe "multiple choice question" do
      it "route to multiple choice path" do
        get :show, :id => @multiple_choice_question.id
        response.should redirect_to(multiple_choice_path(@multiple_choice))
      end
    end

    describe "follow pattern question" do
      it "route to multiple choice path" do
        get :show, :id => @follow_pattern_question.id
        response.should redirect_to(@follow_pattern)
      end
    end
  end

  describe "GET edit" do
    describe "multiple choice question" do
      it "route question to multiple choice edit path" do
        get :edit, :id => @multiple_choice_question.id
        response.should redirect_to(edit_multiple_choice_path(@multiple_choice))
      end
    end

    describe "follow pattern question" do
      it "route question to multiple choice edit path" do
        get :edit, :id => @follow_pattern_question.id
        response.should redirect_to(edit_follow_pattern_path(@follow_pattern))
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question" do
      delete :destroy, :id => @multiple_choice_question.id
      Question.find_by_id(@multiple_choice_question.id).should == nil
    end

    it "redirects to the questions list" do
      delete :destroy, :id => @multiple_choice_question.id
      response.should redirect_to(questions_path)
    end
  end

end
