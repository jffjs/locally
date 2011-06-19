require 'spec_helper'

describe AnswersController do
  let(:question)      { mock_model(Question).as_null_object }
  let(:answer)        { mock_model(Answer).as_null_object }
  let(:current_user)  { mock_model(User).as_null_object }
  
  before do
    controller.stub(:authenticate_user!).and_return(true)
    controller.stub(:current_user).and_return(current_user)
  end
  
  describe "POST create" do
    before do
      @attr = {'content' => "This is an answer"}
      Question.stub(:where).and_return(question)
    end
    
    it "finds the related question" do
      Question.should_receive(:where).with(:sequence => question.id)
      post :create, :answer => @attr, :question_id => question.id
    end
    
    it "adds the Answer to the Question" do
      pending "Make this better"
    end
    
    it "adds the current user to the list of question answerers" do
      question.stub(:answerers).and_return([])
      question.answerers.should_receive(:<<).with(current_user)
      post :create, :answer => @attr, :question_id => question.id
    end
    
    it "adds the question to the user's list of answered questions" do
      current_user.stub(:answered_questions).and_return([])
      current_user.answered_questions.should_receive(:<<).with(question)
      post :create, :answer => @attr, :question_id => question.id
    end
  end
end
