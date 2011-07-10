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
  
  describe "#find_by_google_ref" do
    let(:google_client) { double("GooglePlaces::Client").as_null_object }
    let(:place) { double("GooglePlaces::Place").as_null_object }
    let(:ref) { "CnRoAAAAtQ-Rcf7nDYg9oBoeVVgpoZ1bZywuJsGc1S_31GbnQJYGRHmOwfAb-YZyA_8a1y67CBI1FY1nKKS9xKHrQ-WghUV0nGjPD3UnX5VmTiSrLAZse_uj5VD0EUgUls7R75xTcRkYZ2ecA_n8F971aj_WCRIQ_rUGKOZtFSZ687hF-TLLAxoUJ-HQ89GZDMq6PRXmvlR-pwqxVwo" }
    
    it "should invoke the GooglePlaces API" do
      GooglePlaces::Client.should_receive(:new).and_return(google_client)
      google_client.should_receive(:spot).with(ref).and_return(place)
      Place.find_by_google_ref(ref)
    end
    
    it "returns the referenced Place" do
      p = Place.find_by_google_ref(ref)
      p.google_id.should == '8043b3ac72884d2c0b6954399bdc091e3b7fe175'
    end
  end
end
