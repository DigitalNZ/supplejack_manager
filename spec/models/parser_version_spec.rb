require "spec_helper"

describe ParserVersion do
  before do
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
  end

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

  describe "#post_changes" do
    before(:each) do
      version.user = FactoryGirl.build(:user)
      version.parser = FactoryGirl.build(:parser)
    end

    context "tagged as production" do
      it "should post to changes app" do
        version.tags = ["production"]
        RestClient::Request.should_receive(:execute).with(anything())
        version.post_changes
      end
    end

    context "untagged as production" do
      it "should not post to changes app" do
        version.tags = ["staging"]
        RestClient::Request.should_not_receive(:execute).with(anything())
        version.post_changes
      end
    end
  end
end