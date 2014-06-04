# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe User do

  let(:user) { FactoryGirl.build(:user, name: "Federico Gonzalez") }

  describe ".active" do
    let!(:deactive) { FactoryGirl.create(:user, name: "Deactivated User", email: 'deactivated@example.com', active: false) }

    it "should return only active users" do
      user.save!
      User.active.count.should eq 1
    end
  end

  describe "validations" do
    it "should be valid" do
      user.should be_valid
    end

    it "should not be valid with an invalid role" do
      user.role = 'not valid'
      user.should_not be_valid
    end
  end

  describe "admin?" do
    it "should return true for an admin" do
      user.role = 'admin'
      user.admin?.should be_true
    end

    it "should return false for a user" do
      user.admin?.should be_false
    end
  end

  describe "#first_name" do
    it "returns the first name" do
      user.first_name.should eq "Federico"
    end

    it "returns nil when name is not present" do
      user.name = nil
      user.first_name.should be_nil
    end
  end

  describe "active_for_authentication?" do
    context "active user" do
      it "should return true" do
        user.active = true
        user.active_for_authentication?.should be_true
      end
    end
    
    context "in-active user" do
      it "should return false" do
        user.active = false
        user.active_for_authentication?.should be_false
      end
    end
  end

  describe "run_harvest_partners=" do
    it "should remove the blank entries" do
      user.run_harvest_partners=(['a', '', 'c'])
      user.run_harvest_partners.should eq ['a', 'c'] 
    end
  end
end