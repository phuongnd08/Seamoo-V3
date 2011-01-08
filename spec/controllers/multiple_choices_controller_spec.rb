require 'spec_helper'

describe MultipleChoicesController do

  before(:each) do
    @question = Question.create_multiple_choices("Who are you", {"a" => false, "b" => false, "c" => false, "d" => true})
    @multiple_choice = @question.data
  end

  describe "GET show" do
    it "assigns the requested multiple_choice as @multiple_choice" do
      get :show, :id => @multiple_choice.id
      assigns(:multiple_choice).should == @multiple_choice
    end
  end

  describe "GET new" do
    it "assigns a new multiple_choice as @multiple_choice" do
      get :new
      assigns(:multiple_choice).should be_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested multiple_choice as @multiple_choice" do
      get :edit, :id => @multiple_choice.id
      assigns(:multiple_choice).should == @multiple_choice
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "create new question" do
        lambda{
          post :create, :multiple_choice => {'content' => 'Content'}
        }.should change(Question, :count).by(1)
      end

      it "redirects to the created question" do
        post :create, :multiple_choice => {'content' => 'Content'}
        response.should redirect_to(MultipleChoice.find_by_content('Content').question)
      end
    end

    describe "with invalid params" do
      before(:each) do
        @multiple_choice = mock_model(MultipleChoice)
        @multiple_choice.stub(:save => false)
        MultipleChoice.stub(:new).with({'these' => 'params'}) { @multiple_choice }

      end
      it "assigns a newly created but unsaved multiple_choice as @multiple_choice" do
        post :create, :multiple_choice => {'these' => 'params'}
        assigns(:multiple_choice).should be(@multiple_choice)
      end

      it "re-renders the 'new' template" do
        post :create, :multiple_choice => {'these' => 'params'}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do
    before(:each) do
      MultipleChoice.should_receive(:find).with(@multiple_choice.id) { @multiple_choice }
    end
    describe "with valid params" do
      it "updates the requested multiple_choice" do
        @multiple_choice.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @multiple_choice.id, :multiple_choice => {'these' => 'params'}
      end

      it "redirects to the question" do
        put :update, :id => @multiple_choice.id
        response.should redirect_to(question_path(@question))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @multiple_choice.stub(:update_attributes => false)
      end
      it "assigns the multiple_choice as @multiple_choice" do
        put :update, :id => @multiple_choice.id
        assigns(:multiple_choice).should == @multiple_choice
      end

      it "re-renders the 'edit' template" do
        put :update, :id => @multiple_choice.id
        response.should render_template("edit")
      end
    end

  end
end
