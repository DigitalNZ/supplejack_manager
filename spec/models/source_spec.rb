require 'spec_helper'

describe Source do
  before do 
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      s = FactoryGirl.build(:source)
      s.valid?.should be_true
    end

    it "is not valid without a name" do
      s = FactoryGirl.build(:source, name: nil)
      s.valid?.should be_false
    end

    it "is not valid without a source_id" do
      s = FactoryGirl.build(:source, source_id: nil)
      s.valid?.should be_false
    end

    it "must have a partner" do
      s = FactoryGirl.build(:source, partner_id: nil)
      s.valid?.should be_false
    end

    it "must have a unique source_id" do
      s1 = FactoryGirl.create(:source, source_id: 'test')
      s2 = FactoryGirl.build(:source, source_id: 'test')

      s2.valid?.should be_false
    end
  end

  describe "after save" do 
    it "calls update_apis" do
      s = FactoryGirl.build(:source)
      s.should_receive(:update_apis)
      s.save
    end
  end

  describe "#update_apis" do
    let(:source) {FactoryGirl.build(:source)}

    before do
      Source.any_instance.unstub(:update_apis)
      RestClient.stub(:post)
    end

    it "updates the source" do
      RestClient.should_receive(:post).with("http://api.uat.digitalnz.org/partners/#{source.partner.id.to_s}/sources",source: source.attributes)
      source.update_apis
    end

    it "updates each backend_environment" do
      BACKEND_ENVIRONMENTS = [:staging, :production]
      RestClient.should_receive(:post).with("http://api.uat.digitalnz.org/partners/#{source.partner.id.to_s}/sources",anything)
      RestClient.should_receive(:post).with("http://api.dnz03.digitalnz.org/partners/#{source.partner.id.to_s}/sources",anything)
      source.update_apis
    end

    it "syncs the partner" do
      source.partner.should_receive(:update_apis)
      source.update_apis
    end
  end
end
