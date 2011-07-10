class QuestionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # GET /questions
  def index
    if params[:location]
      @coords = Geokit::Geocoders::GoogleGeocoder.geocode(params[:location]).ll
      @location = params[:location]
    elsif user_signed_in?
      @coords = current_user.ll
      @location = current_user.location
    else
      # TODO: change IP address to request.remote_ip when you deploy
      location = Geokit::Geocoders::IpGeocoder.geocode("24.11.161.183")
      @coords = location.ll
      @location = "#{location.city} #{location.state}"
    end
    
    #TODO: make a scope for this query
    @questions = Question.near(split_ll(@coords), 20)
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # GET /questions/edit/:id
  def edit
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  # GET /questions/:id
  def show
    @question = Question.find(params[:id])
    @coords = "#{@question.latitude},#{@question.longitude}"
    @new_answer = Answer.new
    @answers = @question.answers.order('created_at desc') # TODO: change this to most popular

    respond_to do |format|
      format.html
    end
  end
  
  # GET /questions/new
  def new
    if params[:coords]
      @coords = params[:coords]
    else
      @coords = current_user.ll
    end

    @question = Question.new(:ll => @coords)

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
  
  private
  
  # Splits a lat,lng string into an array of floats
  # e.g. "20.0,-50.0" => [20.0, -50.0]
  def split_ll(ll_string)
    ll_string.split(/ |,/).map { |l| l.to_f }
  end
end
