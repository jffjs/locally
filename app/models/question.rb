class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  extend  Mongoid::Geo::Near

  field :content, :type => String
  field :slug,    :type => String
  field :coords,  :type => Array, :geo => true
  embeds_many :answers
  referenced_in :user, :inverse_of => :asked_questions
  references_and_referenced_in_many :answerers, :class_name => "User", :inverse_of => :answered_questions
  auto_increment :sequence
  geo_index :coords

  validates :content, :presence => true
  before_save   :generate_slug
  
  protected
  
  def generate_slug
    self.slug = content.parameterize
  end
end
