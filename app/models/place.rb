class Place < ActiveRecord::Base
  has_many :answers
  geocoded_by :full_address
  
  # We may need the google reference, but don't want to persist it as it is not stable
  def google_reference
    @ref
  end
  
  def google_reference=(value)
    @ref = value
  end
  
  def self.find_by_google(lat, lng, opt={})
    @client = GooglePlaces::Client.new('AIzaSyAfmQSf_woizu1OtMiZPP0uGzRvpVv4k2c')
    places = @client.spots(lat, lng, opt)
    places.map do |place|
      self.new(:name => place.name,
               :latitude => place.lat,
               :longitude => place.lng,
               :google_reference => place.reference,
               :google_id => place.id)
    end
  end
  
  def self.find_by_google_ref(ref)
    @client = GooglePlaces::Client.new('AIzaSyAfmQSf_woizu1OtMiZPP0uGzRvpVv4k2c')
    place = @client.spot(ref)
    self.new(:name => place.name,
             :latitude => place.lat,
             :longitude => place.lng,
             :google_id => place.id,
             :full_address => place.formatted_address)
  end
end
