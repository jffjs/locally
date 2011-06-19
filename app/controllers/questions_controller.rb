class QuestionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # GET /questions
  def index
    if params[:location]
      @coords = Geokit::Geocoders::GoogleGeocoder.geocode(params[:location]).ll.split(',')
      @location = params[:location]
    elsif user_signed_in?
      @coords = current_user.coords
      @location = current_user.location
    else
      # TODO: change IP address to request.remote_ip when you deploy
      location = Geokit::Geocoders::IpGeocoder.geocode("24.11.161.183")
      @coords = location.ll.split(',')
      @location = "#{location.city} #{location.state}"
    end
    
    #TODO: make a scope for this query
    @questions = Question.where(:coords.nearMax => [@coords, 1])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # GET /questions/edit/:id
  def edit
    @question = Question.where(:_id => params[:id]).first

    respond_to do |format|
      format.html
    end
  end
  
  # GET /questions/:id
  def show
    @question = Question.where(:sequence => params[:sequence], :slug => params[:slug]).first
    @coords = @question.coords
    @new_answer = Answer.new
    @answers = @question.answers.order_by(:created_at.desc)

    respond_to do |format|
      format.html
    end
  end
  
  # GET /questions/new
  def new
    if params[:coords]
      @coords = params[:coords].split(',')
    else
      @coords = current_user.coords
    end
    
    @question = Question.new

    respond_to do |format|
      format.html
    end
  end
  
  # POST /questions
  def create
    @question = Question.new(params[:question])
    @question.user = current_user
    
    if @question.save
      redirect_to question_pretty_path(@question)
    else
      render :new
    end
  end
end
