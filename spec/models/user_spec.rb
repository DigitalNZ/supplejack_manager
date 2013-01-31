require "spec_helper"

describe User do

  let(:user) { FactoryGirl.build(:user, name: "Federico Gonzalez") }

  describe "#first_name" do
    it "returns the first name" do
      user.first_name.should eq "Federico"
    end

    it "returns nil when name is not present" do
      user.name = nil
      user.first_name.should be_nil
    end
  end
end