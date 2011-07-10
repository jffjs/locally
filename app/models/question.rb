class Question < ActiveRecord::Base
  has_many :answers, :dependent => :destroy
  belongs_to  :user
  has_many :answerers, :through => :answers, :source => :user
  geocoded_by :location
  
  validates :content, :presence => true
  before_save :generate_slug
  
  def ll
    "#{latitude},#{longitude}" if geocoded?
  end
  
  def ll=(value)
    coords = value.split(/ |,/)
    self.latitude = coords[0].to_f
    self.longitude = coords[1].to_f
  end
  
  protected
  
  def generate_slug
    self.slug = content.parameterize
  end
end
