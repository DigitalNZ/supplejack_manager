# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HarvestSchedule do
  let(:schedule) { HarvestSchedule.new(recurrent: true) }
  let(:parser) do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    build(:parser)
  end

  context 'class methods' do
    describe '.find_from_environment' do
      it 'should perform the normal find_all operation but for the specified environment' do
        expect(HarvestSchedule).to receive(:change_worker_env!)
        expect(HarvestSchedule).to receive(:find).with(:all, params: { harvest_schedule: {} })
        HarvestSchedule.find_from_environment({}, 'staging')
      end
    end
  end

  describe '.destroy_all_for_parser' do
    let(:mock_schedule_1) { build(:harvest_schedule) }
    let(:mock_schedule_2) { build(:harvest_schedule) }
    let(:mock_schedule_3) { build(:harvest_schedule) }

    context 'staging' do
      before { allow(Rails).to receive(:env) { 'staging' } }
      it 'should send a delete request for all of the schedules associated with the given parser' do
        expect(HarvestSchedule).to receive(:find_from_environment).with({ parser_id: parser.id }, Rails.env) { [mock_schedule_1, mock_schedule_2] }
        expect(HarvestSchedule).to receive(:delete).with(mock_schedule_1.id)
        expect(HarvestSchedule).to receive(:delete).with(mock_schedule_2.id)
        HarvestSchedule.destroy_all_for_parser(parser.id)
      end
    end

    context 'development' do
      before { allow(Rails).to receive(:env) { 'development' } }
      it 'should send a delete request for all of the schedules associated with the given parser' do
        expect(HarvestSchedule).to receive(:find_from_environment).with({ parser_id: parser.id }, 'development') { [mock_schedule_3] }
        expect(HarvestSchedule).to receive(:delete).with(mock_schedule_3.id)
        HarvestSchedule.destroy_all_for_parser(parser.id)
      end
    end
  end

  describe 'oai?' do
    context 'without parser' do
      before { allow(schedule).to receive(:parser) { nil } }

      it 'should return false' do
        expect(schedule.oai?).to be false
      end
    end

    context 'with parser' do
      before { allow(schedule).to receive(:parser) { parser } }

      it 'should return true when is a oai parser' do
        allow(parser).to receive(:oai?) { true }
        expect(schedule.oai?).to be true
      end

      it 'should return false when is not a oai parser' do
        allow(parser).to receive(:oai?) { false }
        expect(schedule.oai?).to be false
      end
    end
  end
end
