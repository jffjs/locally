require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the QuestionsHelper. For example:
#
# describe QuestionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe QuestionsHelper do
  describe "#question_pretty_path" do
    it "creates an SEO friendly path to the question" do
      question = mock_model(Question)
      question.stub(:id).and_return(113)
      question.stub(:slug).and_return("this-is-a-question-slug")
      question_pretty_path(question).should == "/questions/113/this-is-a-question-slug"
    end
  end
end
