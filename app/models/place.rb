class Place
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :answers
  field :coords,  :type => Array, :geo => true
  field :name
  field :full_address
  field :google_id
  field :google_reference
  geo_index :coords   # need to create the index manually in console: Place.create_index!
  
  def self.find_by_google(lat, lng, opt={})
    @client = GooglePlaces::Client.new('AIzaSyAfmQSf_woizu1OtMiZPP0uGzRvpVv4k2c')
    places = @client.spots(lat, lng, opt)
    places.map do |place|
      self.new(:name => place.name,
               :coords => "#{place.lat},#{place.lng}",
               :google_id => place.id,
               :google_reference => place.reference)
    end
  end
  
  def self.find_by_google_ref(ref)
    @client = GooglePlaces::Client.new('AIzaSyAfmQSf_woizu1OtMiZPP0uGzRvpVv4k2c')
    place = @client.spot(ref)
    self.new(:name => place.name,
             :coords => "#{place.lat},#{place.lng}",
             :google_id => place.id,
             :google_reference => ref,
             :full_address => place.formatted_address)
  end
end
