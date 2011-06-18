require 'spec_helper'

describe Question do
  let(:question) { Question.new :content => "Where can I get a pogo stick?" }
  
  describe "validations" do
    it "requires presence of content" do
      question.content = ""
      question.should_not be_valid
    end
  end
  
  describe "callbacks" do
    describe "before_save" do
      it "should have have an empty slug before saved" do
        question.slug.should == nil
      end
      
      it "should have a parameterized slug of content after saved" do
        parameterized = question.content.parameterize
        question.save
        question.slug.should == parameterized
      end
    end
  end
end
