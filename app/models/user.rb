class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  field :username,  :type => String
  field :location,  :type => String
  field :coords,    :type => Array, :geo => true
  references_many :asked_questions,     :class_name => "Question"
  references_and_referenced_in_many :answered_questions,  :class_name => "Question", :inverse_of => :answerers

  key :username
  validates :username,  :presence   => true,
                        :length     => {:minimum => 3, :maximum => 20},
                        :uniqueness => true

  before_save :update_coords

  protected
  def initialize_sequence
    self.sequence = 0
  end

  def update_coords
    self.coords = Geokit::Geocoders::GoogleGeocoder.geocode(location)
  end
end
