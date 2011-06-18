module QuestionsHelper
  def question_pretty_path(question)
    question_path(:sequence => question.sequence, :slug => question.slug)
  end
end
