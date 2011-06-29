require 'spec_helper'

describe ApplicationHelper do
  describe "#coords_to_string" do
    it "converts cooridinate array of lat,lng into a string" do
      coords = [42, -84]
      coords_to_string(coords).should == "42,-84"
    end
  end
end