class PlacesController < ApplicationController
  # GET /places
  def index
    lat, lng = params[:ll].split(',')
    @places = Place.find_by_google(lat, lng, :name => params[:q])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
end
