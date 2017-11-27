# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require "spec_helper"

describe HarvestSchedule do

  let(:schedule) { HarvestSchedule.new(recurrent: true) }
  let(:parser) { double(:parser, id: 1).as_null_object }

  context "class methods" do
    describe ".find_from_environment" do
      it "should perform the normal find_all operation but for the specified environment" do
        expect(HarvestSchedule).to receive(:change_worker_env!)
        expect(HarvestSchedule).to receive(:find).with(:all, params: {:harvest_schedule => {}})
        HarvestSchedule.find_from_environment({},'staging')
      end
    end
  end

  describe ".destroy_all_for_parser" do
    let(:mock_schedule_1) { double(:schedule, id: 1) }
    let(:mock_schedule_2) { double(:schedule, id: 2) }
    let(:mock_schedule_3) { double(:schedule, id: 3) }

    context "staging" do
      before { allow(Rails).to receive(:env) { "staging" } }
      it "should send a delete request for all of the schedules associated with the given parser" do
        expect(HarvestSchedule).to receive(:find_from_environment).with({parser_id: parser.id}, 'staging') { [mock_schedule_1, mock_schedule_2] }
        expect(HarvestSchedule).to receive(:delete).with(mock_schedule_1.id)
        expect(HarvestSchedule).to receive(:delete).with(mock_schedule_2.id)
        expect(HarvestSchedule).to receive(:find_from_environment).with({parser_id: parser.id}, 'production') { [mock_schedule_3] }
        expect(HarvestSchedule).to receive(:delete).with(mock_schedule_3.id)
        HarvestSchedule.destroy_all_for_parser(parser.id)
      end
    end

    context "development" do
      before { allow(Rails).to receive(:env) { "development" } }
      it "should send a delete request for all of the schedules associated with the given parser" do
        expect(HarvestSchedule).to receive(:find_from_environment).with({parser_id: parser.id}, 'development') { [mock_schedule_3] }
        expect(HarvestSchedule).to receive(:delete).with(mock_schedule_3.id)
        HarvestSchedule.destroy_all_for_parser(parser.id)
      end
    end
  end

  describe "oai?" do
    context "without parser" do
      before { allow(schedule).to receive(:parser) {nil} }

      it "should return false" do
        expect(schedule.oai?).to be false
      end
    end

    context "with parser" do
      before { allow(schedule).to receive(:parser) { parser } }

      it "should return true when is a oai parser" do
        allow(parser).to receive(:oai?) { true }
        expect(schedule.oai?).to be true
      end

      it "should return false when is not a oai parser" do
        allow(parser).to receive(:oai?) { false }
        expect(schedule.oai?).to be false
      end
    end
  end
end
