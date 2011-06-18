require 'spec_helper'

describe User do
  let(:user) { User.new(:email => "test@test.com", :username => "test",
                        :password => "password", :password_confirmation => "password") }

  describe "validations" do
    it "should require username to have at least 3 characters" do
      user.username = "aa"
      user.should_not be_valid
    end

    it "should require username to have less than 20 characters" do
      user.username = "a" * 21
      user.should_not be_valid
    end

    it "should require username to be unique" do
      another_user = Factory.build(:user, :username => "test")
      user.should_not be_valid
    end

    it "should require username to be present" do
      user.username = ""
      user.should_not be_valid
    end

    it "should require email to be unique" do
      another_user = Factory.build(:user, :email => "test@test.com")
      user.should_not be_valid
    end

    it "should require password and password confirmation to match" do
      user.password_confirmation = "password1"
      user.should_not be_valid
    end
  end
  
  describe "callbacks" do
    describe "before_save" do
      it "should update the user's coords based on location" do
        coords = [80, -50]
        Geokit::Geocoders::GoogleGeocoder.stub(:geocode).and_return(coords)
        user.save
        user.reload
        user.coords.should == coords
      end
    end
  end
end
