# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require 'spec_helper'

describe Partner do
  before do
    RestClient.stub(:post)
  end

  describe "validations" do
    it "is not valid without a name" do
      p = Partner.new
      p.valid?.should be_false
    end

    it "is not valid unless name is unique" do
      p1 = FactoryGirl.create(:partner, name: 'partner')
      p2 = FactoryGirl.build(:partner, name: 'partner')
      p2.valid?.should be_false
    end
  end

  describe "after save" do
    it "syncs with the apis" do
      p = FactoryGirl.build(:partner)
      p.should_receive(:update_apis)
      p.save
    end
  end

  describe "#update_apis" do
    let(:partner) {FactoryGirl.create(:partner)}

    it "updates the partner" do
      RestClient.should_receive(:post).with("http://api.uat.digitalnz.org/harvester/partners",partner: partner.attributes)
      partner.update_apis
    end

    it "updates each environments" do
      APPLICATION_ENVS.each do |env|
        env = Figaro.env(env)
        RestClient.should_receive(:post).with("#{env['API_HOST']}/harvester/partners", anything)
        partner.update_apis
      end
    end
  end
end
