# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'rails_helper'

describe Source do
  let(:source) { build(:source) }

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(source.valid?).to be true
    end

    it "is not valid without a name" do
      s = build(:source, name: nil)
      expect(s.valid?).to be false
    end

    it "is not valid without a source_id" do
      s = build(:source, source_id: nil)
      # create_source_id is called before validation so if it is
      # not stubbed then the source id will be set.
      allow(s).to receive(:create_source_id)
      expect(s.valid?).to be false
    end

    it "must have a partner" do
      s = build(:source, partner_id: nil)
      expect(s.valid?).to be false
    end

    it "must have a unique source_id" do
      s1 = create(:source, source_id: 'test')
      s2 = build(:source, source_id: 'test')

      expect(s2.valid?).to be false
    end
  end

  describe "after create" do
    it "calls create_link_check_rule" do
      expect(source).to receive(:create_link_check_rule)
      source.save
    end
  end

  describe "after save" do
    it "calls update_apis" do
      expect(source).to receive(:update_apis)
      source.save
    end
  end

  describe "#create_link_check_rule" do
    it "should create the rule in each backend_environment" do
      APPLICATION_ENVS.each do |env|
        expect(source).to receive(:set_worker_environment_for).with(LinkCheckRule, env)
        expect(LinkCheckRule).to receive(:create)
      end
      source.send(:create_link_check_rule)
    end

    it "should create an inactive LinkCheckRule" do
      expect(LinkCheckRule).to receive(:create).with(source_id: source.id, active: false)
      source.send(:create_link_check_rule)
    end
  end

  describe "#create_source_id" do
    context "a source with a source_id" do
      it "doesn't create a source_id if one exists" do
        current_source_id = source.source_id
        source.send(:create_source_id)
        expect(source.source_id).to eq current_source_id
      end
    end

    context "creating a new source" do
      let(:new_source) { Source.new(name: "New source", partner: 123) }

      it "creates a new source_id using the name" do
        new_source.send(:create_source_id)
        expect(new_source.source_id).to eq "new_source"
      end

      it "removes excess whitespace and replaces them with underscores in the source_id" do
        new_source.name = "New      Source     4"
        new_source.send(:create_source_id)
        expect(new_source.source_id).to eq "new_source_4"
      end

      it "only includes alphanumeric characters in the source_id" do
        new_source.name = "@New 84 $ource!!"
        new_source.send(:create_source_id)
        expect(new_source.source_id).to eq "new_84_ource"
      end
    end
  end
end
