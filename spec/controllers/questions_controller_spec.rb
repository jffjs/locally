require 'spec_helper'

describe QuestionsController do
  let(:question) { mock_model(Question).as_null_object }
  let(:current_user) { mock_model(User).as_null_object }
  let(:coords) { "80.0, -50.0" }
  
  before do
    controller.stub(:current_user).and_return(current_user)
  end
  
  describe "GET index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "renders the correct template" do
      get :index
      response.should render_template(:index)
    end
    
    it "finds nearby Questions" do
      Question.should_receive(:where)
      get :index
    end
    
    it "assigns @questions" do
      questions = [question]
      Question.stub(:where).and_return(questions)
      get :index
      assigns[:questions].should == questions
    end
    
    context "when params[:new_coords] exists" do
      before do
        get :index, :new_coords => coords, :location => "Lansing, MI"
      end
      
      it "assigns @coords" do
        assigns[:coords].should == coords.split(',')
      end
      
      it "assigns @location" do
        assigns[:location].should == "Lansing, MI"
      end
    end
      
    context "when params[:new_coords] does not exist and a user is signed in" do
      before do
        controller.stub(:user_signed_in?).and_return(true)
      end
      
      it "assigns @coords" do
        current_user.stub(:coords).and_return(coords)
        get :index
        assigns[:coords].should == coords
      end
      
      it "assigns @location" do
        current_user.stub(:location).and_return("Lansing, MI")
        get :index
        assigns[:location].should == "Lansing, MI"
      end
    end
    
    context "when params[:new_coords] does not exist and user is not signed in" do
      let(:location) { double().as_null_object }
      
      before do
        controller.stub(:user_signed_in?).and_return(false)
        Geokit::Geocoders::IpGeocoder.stub(:geocode).and_return(location)
      end
      
      it "should lookup coords based on IP address" do
        Geokit::Geocoders::IpGeocoder.should_receive(:geocode)
        get :index
      end
      
      it "assigns @coords" do
        coords_split = coords.split(',')
        location.stub_chain(:ll, :split).and_return(coords_split)
        get :index
        assigns[:coords].should == coords_split
      end
      
      it "assigns @location" do
        location.stub(:city).and_return("Lansing")
        location.stub(:state).and_return("MI")
        get :index
        assigns[:location].should == "Lansing MI"
      end
    end
  end
  
  describe "GET new" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "creates a new Question" do
      Question.should_receive(:new)
      get :new
    end
    
    it "assigns @question" do
      Question.stub(:new).and_return(question)
      get :new
      assigns[:question].should == question
    end
    
    it "assigns @coords" do
      current_user.stub(:coords).and_return(coords)
      get :new
      assigns[:coords].should == coords
    end
  end
  
  describe "POST create" do
    before do
      @attr = { 'content' => "Where can I buy a pogo stick?" }
      Question.stub(:new).and_return(question)
    end
    
    it "creates a new Question from the parameters" do
      Question.should_receive(:new).with(@attr)
      post :create, :question => @attr
    end
    
    it "saves the Question" do
      question.should_receive(:save)
      post :create, :question => @attr
    end
    
    context "when it saves successfully" do
      before do
        question.stub(:save).and_return(true)
      end
      
      it "should redirect to show" do
        post :create, :question => @attr
        response.should redirect_to(question_path(:sequence => question.sequence,
                                                  :slug => question.slug ))
      end
    end
    
    context "when it fails to save" do
      before do
        question.stub(:save).and_return(false)
      end
      
      it "should render the new template" do
        post :create, :question => @attr
        response.should render_template(:new)
      end
      
      it "assigns @question" do
        post :create, :question => @attr
        assigns[:question].should == question
      end
    end
  end
  
  describe "GET edit" do
    before do
      Question.stub(:where).and_return(question)
    end
    
    it "should be successful" do
      get :edit, :id => question.id
      response.should be_success
    end
    
    it "finds the requested Question" do
      Question.should_receive(:where).with( :_id => question.id)
      get :edit, :id => question.id
    end
    
    it "assigns @question" do
      get :edit, :id => question.id
      assigns[:question].should == question
    end
    
    it "renders the correct template" do
      get :edit, :id => question.id
      response.should render_template(:edit)
    end
  end
  
  describe "GET show" do
    before do 
      Question.stub(:where).and_return(question)
    end
    
    it "should be successful" do
      get :show, :sequence => question.sequence, :slug => question.slug
      response.should be_success
    end
    
    it "finds the requested Question" do
      Question.should_receive(:where).with(:sequence => question.sequence,
                                           :slug => question.slug)
      get :show, :sequence => question.sequence, :slug => question.slug
    end
    
    it "assigns @qustion" do
      get :show, :sequence => question.sequence, :slug => question.slug
      assigns[:question].should == question
    end
    
    it "assigns @coords" do
      question.stub(:coords).and_return(coords)
      get :show, :sequence => question.sequence, :slug => question.slug
      assigns[:coords].should == coords
    end
    
    it "creates a new Answer" do
      Answer.should_receive(:new)
      get :show, :sequence => question.sequence, :slug => question.slug
    end
    
    it "assigns @new_answer" do
      new_answer = Answer.new
      Answer.stub(:new).and_return(new_answer)
      get :show, :sequence => question.sequence, :slug => question.slug
      assigns[:new_answer].should == new_answer
    end
    
    it "assigns @answers" do
      answers = [mock_model(Answer)]
      question.stub_chain(:answers, :order_by).and_return(answers)
      get :show, :sequence => question.sequence, :slug => question.slug
      assigns[:answers].should == answers
    end
    
    it "renders the correct template" do
      get :show, :sequence => question.sequence, :slug => question.slug
      response.should render_template(:show)
    end
  end
end
