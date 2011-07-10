class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_name, 
                  :location       
  #references_many :asked_questions,     :class_name => "Question"
  #references_and_referenced_in_many :answered_questions,  :class_name => "Question", :inverse_of => :answerers
  has_many  :asked_questions, :class_name => "Question"
  has_many  :answers
  has_many  :answered_questions,  :through => :answers, :source => :question

  geocoded_by :location
  after_validation :geocode
  
  validates :user_name, :presence   => true,
                        :length     => {:minimum => 3, :maximum => 20},
                        :uniqueness => true

  def ll
    "#{latitude},#{longitude}"
  end
end
