# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  let(:user)          { FactoryBot.create(:user) }
  let(:user_ability)  { Ability.new(user) }
  let(:admin_ability) { Ability.new(FactoryBot.create(:user, role: 'admin')) }

  before(:each) do
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
    Source.any_instance.stub(:create_link_check_rule)

    # Can't use let() as they are invoked before above stubs
    @partner = FactoryBot.create(:partner)
    @source = FactoryBot.create(:source, partner: @partner)
    @parser = FactoryBot.create(:parser, source: @source)
    @harvest_schedule = HarvestSchedule.create(parser_id: @parser.id, recurrent: false)
    @link_check_rule = instance_double(LinkCheckRule, source_id: @source.id).as_null_object
  end

  describe 'user' do
    it 'should be able to read everything' do
      user_ability.should be_able_to(:read, Parser)
    end

    it "should not be able to read collection_record" do
      user_ability.should_not be_able_to(:read, :collection_record)
    end

    describe "users" do
      it "should be able to update own user" do
        user_ability.should be_able_to(:update, user)
      end

      it "should not be able to update other users" do
        user_ability.should_not be_able_to(:update, FactoryBot.build(:user))
      end
    end

    context "sources" do
      before(:each) {
        user.manage_data_sources = true
      }

      it "should be able to create data sources" do
        user_ability.should be_able_to(:create, Source)
      end

      it "should be able to update the data source" do
        user.update_attribute(:manage_partners, [@partner.id.to_s])
        user_ability.should be_able_to(:update, @source)
      end
    end

    context "parsers" do
      before(:each) {
        user.manage_parsers = true
      }

      it "should be able to create Parsers" do
        user_ability.should be_able_to(:create, Parser)
      end

      context "manage_partners" do
        before(:each) {
          user.update_attribute(:manage_partners, [@partner.id.to_s])
        }

        it 'should be able to update the parser' do
          user_ability.should be_able_to(:update, @parser)
        end

        it 'should be able to preview the parser' do
          user_ability.should be_able_to(:preview, @parser)
        end
      end

      it "should be able to create Parser Templates" do
        user_ability.should be_able_to(:create, ParserTemplate)
      end

      it "should be able to create Snippets" do
        user_ability.should be_able_to(:create, Snippet)
      end

      it "should be able to run harvests for specific partners" do
        user.update_attribute(:run_harvest_partners, [@parser.partner.id.to_s])
        user_ability.should be_able_to(:run_harvest, @parser)
      end
    end

    context "harvest schedules" do
      before(:each) {
        user.manage_harvest_schedules = true
      }

      it "should be able to create Harvest Schedules" do
        user_ability.should be_able_to(:create, HarvestSchedule)
      end

      it "should be able to create the harvest schedule" do
        user.update_attribute(:manage_partners, [@partner.id.to_s])
        user_ability.should be_able_to(:update, @harvest_schedule)
      end
    end

    context "link check rules" do
      before(:each) {
        user.manage_link_check_rules = true
      }

      it "should be able to create Link Check Rules" do
        user_ability.should be_able_to(:create, LinkCheckRule)
      end

      it "should be able to update the link check rule"
        # user.update_attribute(:manage_partners, [@partner.id.to_s])
        # user_ability.should be_able_to(:update, @link_check_rule)
      # end
    end

    it "should not be read collection_record" do
      user_ability.should_not be_able_to(:read, :collection_record)
    end
  end
end
