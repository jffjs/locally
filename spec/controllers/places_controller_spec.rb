require 'spec_helper'

describe PlacesController do
  let(:place) { mock_model(Place).as_null_object }
  
  describe "GET index" do
    let(:coords) { "80.0,-50.0" }
    
    before do
      Place.stub(:find_by_google).and_return([place])
    end
    
    it "finds nearby places by keyword" do
      Place.should_receive(:find_by_google).with("80.0", "-50.0", :name => "italian")
      get :index, :ll => coords, :q => "italian"
    end
    
    it "assigns @places" do
      get :index, :ll => coords, :q => "italian"
      assigns[:places].should == [place]
    end
    
    it "renders the correct template" do
      get :index, :ll => coords, :q => "italian"
      response.should render_template(:index)
    end
  end
end
