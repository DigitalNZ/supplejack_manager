require "spec_helper"

describe ParserVersion do

  let(:version) { ParserVersion.new }
  
  describe "#staging?" do
    context "has staging tag" do
      before { version.tags = ["staging"] }

      it "should return true" do
        version.staging?.should be_true
      end
    end

    context "doesn't have staging tag" do
      before { version.tags = ["production"] }

      it "should return false" do
        version.staging?.should be_false
      end
    end
  end

  describe "#production?" do
    context "has production tag" do
      before { version.tags = ["production"] }

      it "should return true" do
        version.production?.should be_true
      end
    end

    context "doesn't have production tag" do
      before { version.tags = ["staging"] }

      it "should return false" do
        version.production?.should be_false
      end
    end
  end
end