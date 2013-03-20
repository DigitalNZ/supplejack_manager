require "spec_helper"

describe HarvestSchedule do

  let(:schedule) { HarvestSchedule.new(recurrent: true) }
  let(:parser) { mock(:parser).as_null_object }

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