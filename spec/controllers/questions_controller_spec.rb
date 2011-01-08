require 'spec_helper'

describe QuestionsController do

  before(:each) do
    @question = Question.create
  end

  describe "GET index" do
    it "assigns all questions as @questions" do
      get :index
      assigns(:questions).should eq([@question])
    end
  end

  describe "GET show" do
    describe "multiple choice question" do
      before(:each) do
        @multiple_choice = MultipleChoice.create
        @question.update_attribute(:data, @multiple_choice)
      end
      it "route to multiple choice path" do
        get :show, :id => @question.id
        response.should redirect_to(multiple_choice_path(@multiple_choice))
      end
    end
  end

  describe "GET edit" do
    describe "multiple choice question" do
      before(:each) do
        @multiple_choice = MultipleChoice.create
        @question.update_attribute(:data, @multiple_choice)
      end
      it "route question to multiple choice edit path" do
        get :edit, :id => @question.id
        response.should redirect_to(edit_multiple_choice_path(@multiple_choice))
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question" do
      delete :destroy, :id => @question.id
      Question.find_by_id(@question.id).should == nil
    end

    it "redirects to the questions list" do
      delete :destroy, :id => @question.id
      response.should redirect_to(questions_path)
    end
  end

end
