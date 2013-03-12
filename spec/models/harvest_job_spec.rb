require "spec_helper"

describe HarvestJob do

  let(:user) { mock_model(User, id: "333").as_null_object }
  let(:job) { HarvestJob.new(user_id: "1234567", parser_id: "7654321") }

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

  describe ".build" do
    it "initializes a new HarvestJob with default attributes" do
      job = HarvestJob.build
      [:parser_id, :limit, :user_id, :version_id, :environment].each do |attribute|
        job.send(attribute).should be_nil
      end
    end

    it "overrides the attributes passed" do
      job = HarvestJob.build(parser_id: "12345")
      job.parser_id.should eq "12345"
    end
  end

  describe ".search" do
    let(:jobs) { [job] }

    before(:each) do
      HarvestJob.stub(:find) { jobs }
      jobs.stub(:http) { {} }
    end

    it "finds all active harvest jobs" do
      HarvestJob.should_receive(:find).with(:all, params: {status: "active", page: 1, environment: ["staging", "production"]})
      HarvestJob.search.should eq jobs
    end

    it "finds all finished harvest jobs" do
      HarvestJob.should_receive(:find).with(:all, params: {status: "finished", page: 1, environment: ["staging", "production"]})
      HarvestJob.search("status" => "finished")
    end

    it "paginates through the records" do
      HarvestJob.should_receive(:find).with(:all, params: {status: "finished", page: "2", environment: ["staging", "production"]})
      HarvestJob.search("status" => "finished", "page" => "2")
    end
  end

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

  describe "#parser" do
    it "finds the parser based on the parser_id" do
      Parser.should_receive(:find).with("7654321")
      job.parser
    end

    it "returns nil when not found" do
      job.parser.should be_nil
    end

    it "returns nil when no parser_id is present" do
      job = HarvestJob.new
      job.parser.should be_nil
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

  describe "#total_errors_count" do
    it "should add the failed and invalid record counts" do
      job.stub(:failed_records_count) { 5 }
      job.stub(:invalid_records_count) { 3 }
      job.total_errors_count.should eq 8
    end
  end

end
