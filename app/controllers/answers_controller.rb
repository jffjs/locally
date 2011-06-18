class AnswersController < ApplicationController
  
  # POST /answers
  def create
    # Refactor this to nest answers in questions
    # May need to find a more efficient way of doing this
    @question = Question.where(:sequence => params[:question_id]).first
    @question.answers.build(params[:answer])

    @question.answerers << current_user
    current_user.answered_questions << @question

    redirect_to question_pretty_path(@question)
  end
end
