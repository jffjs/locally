class PlacesController < ApplicationController
  # GET /places
  def index
    lat, lng = params[:ll].split(',')
    @places = Place.find_by_google(lat, lng, :query => params[:q])
  end
end
