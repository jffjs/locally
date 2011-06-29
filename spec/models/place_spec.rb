require 'spec_helper'

describe Place do
  describe "#find_by_google" do
    let(:google_client) { double("GooglePlaces::Client").as_null_object }
    
    it "should invoke the GooglePlaces API" do
      GooglePlaces::Client.should_receive(:new).and_return(google_client)
      google_client.should_receive(:spots).with("42", "-84", {}).and_return([])
      Place.find_by_google("42", "-84")
    end
    
    it "returns an array of Places from Google" do
      places = Place.find_by_google("42.7", "-84.5")
      places.should be_an Array
      places[0].should be_a Place
    end
  end
end
