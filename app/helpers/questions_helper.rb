module QuestionsHelper
  def question_pretty_path(question)
    question_path(:id => question.id, :slug => question.slug)
  end
end
