require "spec_helper"

describe HarvestJob do

  describe ".from_parser" do
    let(:parser) { Parser.new }

    it "initializes a new HarvestJob" do
      job = HarvestJob.from_parser(parser)
      job.parser_id.should eq parser.id
    end
  end
  
  it "enqueues a job after_create" do
    HarvestWorker.should_receive(:perform_async)
    HarvestJob.create
  end

  let(:job) { FactoryGirl.build(:harvest_job) }

  describe "#finished?" do
    it "returns true with a end_time" do
      job.end_time = Time.now
      job.finished?.should be_true
    end

    it "returns false without a end_time" do
      job.end_time = nil
      job.finished?.should be_false
    end
  end

end
