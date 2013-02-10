require "spec_helper"

describe HarvestJob do

  let(:user) { mock_model(User, id: "333").as_null_object }

  describe ".from_parser" do
    let(:parser) { mock(:parser, id: "1234") }

    it "initializes a new HarvestJob" do
      job = HarvestJob.from_parser(parser)
      job.parser_id.should eq "1234"
    end

    it "sets the user_id" do
      job = HarvestJob.from_parser(parser, user)
      job.user_id.should eq "333"
    end
  end

  let(:job) { HarvestJob.new(user_id: "1234567") }

  describe "#user" do
    it "finds the user based on the user_id" do
      User.should_receive(:find).with("1234567")
      job.user
    end

    it "returns nil when not found" do
      job.user.should be_nil
    end

    it "returns nil when no user_id is present" do
      job = HarvestJob.new
      job.user.should be_nil
    end
  end

  describe "#finished?" do
    it "returns true" do
      job.status = "finished"
      job.finished?.should be_true
    end

    it "returns false" do
      job.status = "active"
      job.finished?.should be_false
    end
  end

end
