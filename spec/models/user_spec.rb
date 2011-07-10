require 'spec_helper'

describe User do
  let(:user) { User.new(:email => "test@test.com", :user_name => "test",
                        :password => "password", :password_confirmation => "password") }

  describe "validations" do
    it "should require username to have at least 3 characters" do
      user.user_name = "aa"
      user.should_not be_valid
    end

    it "should require username to have less than 20 characters" do
      user.user_name = "a" * 21
      user.should_not be_valid
    end

    it "should require username to be unique" do
      another_user = Fabricate(:user, :user_name => "test")
      user.should_not be_valid
    end

    it "should require username to be present" do
      user.user_name = ""
      user.should_not be_valid
    end

    it "should require email to be unique" do
      another_user = Fabricate(:user, :email => "test@test.com")
      user.should_not be_valid
    end

    it "should require password and password confirmation to match" do
      user.password_confirmation = "password1"
      user.should_not be_valid
    end
  end
end
