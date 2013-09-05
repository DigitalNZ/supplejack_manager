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
      RestClient.should_receive(:post).with("http://api.uat.digitalnz.org/partners",partner: partner.attributes)
      partner.update_apis
    end

    it "updates each backend_environment" do
      BACKEND_ENVIRONMENTS = [:staging, :production]
      RestClient.should_receive(:post).with("http://api.uat.digitalnz.org/partners",anything)
      RestClient.should_receive(:post).with("http://api.dnz03.digitalnz.org/partners",anything)
      partner.update_apis
    end
  end
end
