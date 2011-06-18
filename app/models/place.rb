class Place
  include Mongoid::Document
  include Mongoid::Timestamps

  field :coords,  :type => Array, :geo => true
  field :name
  field :address
  field :city
  field :state
  field :postal_code
  field :foursquare_id
  
  def self.find_by_google
  end
end
