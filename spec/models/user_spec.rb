# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

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