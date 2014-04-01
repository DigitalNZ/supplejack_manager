require 'spec_helper'

describe Source do
  let(:source) {FactoryGirl.build(:source)}

  before do 
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
    LinkCheckRule.stub(:create)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      source.valid?.should be_true
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
      source.should_receive(:update_apis)
      source.save
    end
  end

  describe "after create" do
    it "calls create_link_check_rule" do
      source.should_receive(:create_link_check_rule)
      source.save
    end
  end

  describe "#update_apis" do
    before do
      Source.any_instance.unstub(:update_apis)
      RestClient.stub(:post)
    end

    it "updates the source" do
      RestClient.should_receive(:post).with("http://api.uat.digitalnz.org/partners/#{source.partner.id.to_s}/sources",source: source.attributes)
      source.send(:update_apis)
    end

    it "updates each backend_environment" do
      BACKEND_ENVIRONMENTS = [:staging, :production]
      RestClient.should_receive(:post).with("http://api.uat.digitalnz.org/partners/#{source.partner.id.to_s}/sources",anything)
      RestClient.should_receive(:post).with("http://api.dnz03.digitalnz.org/partners/#{source.partner.id.to_s}/sources",anything)
      source.send(:update_apis)
    end

    it "syncs the partner" do
      source.partner.should_receive(:update_apis)
      source.send(:update_apis)
    end
  end

  describe "#create_link_check_rule" do
    it "should create the rule in each backend_environment" do
      BACKEND_ENVIRONMENTS = [:staging, :production]
      source.should_receive(:set_worker_environment_for).with(LinkCheckRule, :production)
      source.should_receive(:set_worker_environment_for).with(LinkCheckRule, :staging)
      LinkCheckRule.should_receive(:create).twice()
      source.send(:create_link_check_rule)
    end

    it "should create an inactive LinkCheckRule" do
      LinkCheckRule.should_receive(:create).with(source_id: source.id, active: false)
      source.send(:create_link_check_rule)
    end
  end
end
