# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let(:user)          { create(:user) }
  let(:user_ability)  { Ability.new(user) }
  let(:admin_ability) { Ability.new(create(:user, role: 'admin')) }

  before(:each) do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:create_link_check_rule)

    # Can't use let() as they are invoked before above stubs
    @partner = create(:partner)
    @source = create(:source, partner: @partner)
    @parser = create(:parser, source: @source)
    @harvest_schedule = HarvestSchedule.create(parser_id: @parser.id, recurrent: false)
    @link_check_rule = build(:link_check_rule, source_id: @source.id)
  end

  describe 'user' do
    it 'should be able to read everything' do
      expect(user_ability).to be_able_to(:read, Parser)
    end

    it 'should not be able to read collection_record' do
      expect(user_ability).not_to be_able_to(:read, :collection_record)
    end

    describe 'users' do
      it 'should be able to update own user' do
        expect(user_ability).to be_able_to(:update, user)
      end

      it 'should not be able to update other users' do
        expect(user_ability).not_to be_able_to(:update, build(:user))
      end
    end

    context 'sources' do
      before(:each) {
        user.manage_data_sources = true
      }

      it 'should be able to create data sources' do
        expect(user_ability).to be_able_to(:create, Source)
      end

      it 'should be able to update the data source' do
        user.update_attribute(:manage_partners, [@partner.id.to_s])
        expect(user_ability).to be_able_to(:update, @source)
      end
    end

    context 'parsers' do
      before(:each) {
        user.manage_parsers = true
      }

      it 'should be able to create Parsers' do
        expect(user_ability).to be_able_to(:create, Parser)
      end

      context 'manage_partners' do
        before(:each) {
          user.update_attribute(:manage_partners, [@partner.id.to_s])
        }

        it 'should be able to update the parser' do
          expect(user_ability).to be_able_to(:update, @parser)
        end

        it 'should be able to preview the parser' do
          expect(user_ability).to be_able_to(:preview, @parser)
        end
      end

      it 'should be able to create Parser Templates' do
        expect(user_ability).to be_able_to(:create, ParserTemplate)
      end

      it 'should be able to create Snippets' do
        expect(user_ability).to be_able_to(:create, Snippet)
      end

      it 'should be able to run harvests for specific partners' do
        user.update_attribute(:run_harvest_partners, [@parser.partner.id.to_s])
        expect(user_ability).to be_able_to(:run_harvest, @parser)
      end
    end

    context 'harvest schedules' do
      before(:each) {
        user.manage_harvest_schedules = true
      }

      it 'should be able to create Harvest Schedules' do
        expect(user_ability).to be_able_to(:create, HarvestSchedule)
      end

      it 'should be able to create the harvest schedule' do
        user.update_attribute(:manage_partners, [@partner.id.to_s])
        expect(user_ability).to be_able_to(:update, @harvest_schedule)
      end
    end

    context 'link check rules' do
      before(:each) {
        user.manage_link_check_rules = true
      }

      it 'should be able to create Link Check Rules' do
        expect(user_ability).to be_able_to(:create, LinkCheckRule)
      end

      it 'should be able to update the link check rule' do
        user.update_attribute(:manage_partners, [@partner.id.to_s])
        expect(user_ability).to be_able_to(:update, @link_check_rule)
      end
    end

    it 'should not be read collection_record' do
      expect(user_ability).not_to be_able_to(:read, :collection_record)
    end
  end
end
