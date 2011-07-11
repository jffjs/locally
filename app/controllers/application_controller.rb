class ApplicationController < ActionController::Base
  include QuestionsHelper
  
  protect_from_forgery
  
  private
  
  # Splits a lat,lng string into an array of floats
  # e.g. "20.0,-50.0" => [20.0, -50.0]
  def split_ll(ll_string)
    ll_string.split(/ |,/).map { |l| l.to_f }
  end
  
  # Returns lat,lng in string format
  def geocode(query)
    result = Geocoder.search(query).first
    "#{result.latitude},#{result.longitude}"
  end
end
