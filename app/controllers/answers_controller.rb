class AnswersController < ApplicationController
  before_filter :authenticate_user!
  
  # POST /answers
  def create
    @question = Question.find(params[:question_id])
    #answer = Answer.new(params[:answer])
    # Look up Place by reference and add it to the answer
    place = Place.find_by_google_ref(params[:place_ref]) unless params[:place_ref].blank?
    #answer.place = place
    #@question.answers << answer
    #@question.answerers << current_user
    #current_user.answered_questions << @question

    @answer = Answer.new(params[:answer])
    @answer.place = place
    @answer.question = @question
    @answer.user = current_user
    
    if @answer.save
      redirect_to question_pretty_path(@question)
    else
      render 'questions#show'
    end
  end
end
