class AnswersController < ApplicationController
  before_filter :authenticate_user!
  
  # POST /answers
  def create
    @question = Question.where(:sequence => params[:question_id]).first
    answer = Answer.new(params[:answer])
    # Look up Place by reference and add it to the answer
    place = Place.find_by_google_ref(params[:place_ref])
    answer.place = place
    @question.answers << answer
    @question.answerers << current_user
    current_user.answered_questions << @question

    redirect_to question_pretty_path(@question)
  end
end
