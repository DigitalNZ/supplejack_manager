# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

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
      # create_source_id is called before validation so if it is 
      # not stubbed then the source id will be set.
      s.stub(:create_source_id)
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

  describe "before validation" do
    it "calls create_source_id" do
      Source.any_instance.should_receive(:create_source_id)
      Source.create(name: "Test", partner: FactoryGirl.create(:partner))
    end
  end

  describe "after create" do
    it "calls create_link_check_rule" do
      source.should_receive(:create_link_check_rule)
      source.save
    end
  end

  describe "after save" do 
    it "calls update_apis" do
      source.should_receive(:update_apis)
      source.save
    end
  end

  describe "#update_apis" do
    before do
      Source.any_instance.unstub(:update_apis)
      RestClient.stub(:post)
    end

    it "updates the source" do
      RestClient.should_receive(:post).with("#{ENV['API_HOST']}/partners/#{source.partner.id.to_s}/sources",source: source.attributes)
      source.send(:update_apis)
    end

    it "updates each backend_environment" do
      APPLICATION_ENVS.each do |env|
        env = Figaro.env(env)
        RestClient.should_receive(:post).with("#{env['API_HOST']}/partners/#{source.partner.id.to_s}/sources", anything)
        source.send(:update_apis)
      end
    end

    it "syncs the partner" do
      source.partner.should_receive(:update_apis)
      source.send(:update_apis)
    end
  end

  describe "#create_link_check_rule" do
    it "should create the rule in each backend_environment" do
      APPLICATION_ENVS.each do |env|
        source.should_receive(:set_worker_environment_for).with(LinkCheckRule, env)
        LinkCheckRule.should_receive(:create)
        source.send(:create_link_check_rule)  
      end
    end

    it "should create an inactive LinkCheckRule" do
      LinkCheckRule.should_receive(:create).with(source_id: source.id, active: false)
      source.send(:create_link_check_rule)
    end
  end

  describe "#create_source_id" do
    context "a source with a source_id" do
      it "doesn't create a source_id if one exists" do
        current_source_id = source.source_id
        source.send(:create_source_id)
        source.source_id.should eq current_source_id
      end
    end

    context "creating a new source" do
      let(:new_source) { Source.new(name: "New source", partner: 123) }
      
      it "creates a new source_id using the name" do
        new_source.send(:create_source_id)
        new_source.source_id.should eq "new_source"
      end

      it "removes excess whitespace and replaces them with underscores in the source_id" do
        new_source.name = "New      Source     4"
        new_source.send(:create_source_id)
        new_source.source_id.should eq "new_source_4"
      end

      it "only includes alphanumeric characters in the source_id" do
        new_source.name = "@New 84 $ource!!"
        new_source.send(:create_source_id)
        new_source.source_id.should eq "new_84_ource"
      end
    end
  end
end
