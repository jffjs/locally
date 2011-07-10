class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content  # for test purposes now
  field :user
  belongs_to  :place
  embedded_in :question,  :inverse_of => :answers
end
