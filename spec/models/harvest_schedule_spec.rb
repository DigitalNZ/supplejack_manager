require "spec_helper"

describe HarvestSchedule do

  let(:schedule) { HarvestSchedule.new(recurrent: true) }
  let(:parser) { mock(:parser, id: 1).as_null_object }

  context "class methods" do
    describe ".find_from_environment" do
      it "should perform the normal find_all operation but for the specified environment" do
        HarvestSchedule.should_receive(:change_worker_env!)
        HarvestSchedule.should_receive(:find).with(:all, params: {})
        HarvestSchedule.find_from_environment({},'staging')
      end
    end
  end

  describe ".destroy_all_for_parser" do
    let(:mock_schedule_1) { mock(:schedule, id: 1) }
    let(:mock_schedule_2) { mock(:schedule, id: 2) }
    let(:mock_schedule_3) { mock(:schedule, id: 3) }

    context "staging" do
      before { Rails.stub(:env) { "staging" } }
      it "should send a delete request for all of the schedules associated with the given parser" do
        HarvestSchedule.should_receive(:find_from_environment).with({parser_id: parser.id}, 'staging') { [mock_schedule_1, mock_schedule_2] }
        HarvestSchedule.should_receive(:delete).with(mock_schedule_1.id)
        HarvestSchedule.should_receive(:delete).with(mock_schedule_2.id)
        HarvestSchedule.should_receive(:find_from_environment).with({parser_id: parser.id}, 'production') { [mock_schedule_3] }
        HarvestSchedule.should_receive(:delete).with(mock_schedule_3.id)
        HarvestSchedule.destroy_all_for_parser(parser.id)
      end
    end

    context "development" do
      before { Rails.stub(:env) { "development" } }
      it "should send a delete request for all of the schedules associated with the given parser" do
        HarvestSchedule.should_receive(:find_from_environment).with({parser_id: parser.id}, 'development') { [mock_schedule_3] }
        HarvestSchedule.should_receive(:delete).with(mock_schedule_3.id)
        HarvestSchedule.destroy_all_for_parser(parser.id)
      end
    end
  end

  describe "oai?" do
    context "without parser" do
      before { schedule.stub(:parser) {nil} }

      it "should return false" do
        schedule.oai?.should be_false
      end
    end

    context "with parser" do
      before { schedule.stub(:parser) { parser } }

      it "should return true when is a oai parser" do
        parser.stub(:oai?) { true }
        schedule.oai?.should be_true
      end

      it "should return false when is not a oai parser" do
        parser.stub(:oai?) { false }
        schedule.oai?.should be_false
      end
    end
  end
end