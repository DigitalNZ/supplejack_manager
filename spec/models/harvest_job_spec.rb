require "spec_helper"

describe HarvestJob do

  describe ".from_parser" do
    let(:parser) { mock(:parser, strategy: "xml", name: "youtube.rb") }

    it "initializes a new HarvestJob" do
      job = HarvestJob.from_parser(parser)
      job.strategy.should eq "xml"
      job.file_name.should eq "youtube.rb"
    end
  end
  
  it "enqueues a job after_create" do
    HarvestWorker.should_receive(:perform_async)
    HarvestJob.create(strategy: "oai", file_name: "george_grey.rb")
  end

  let(:job) { HarvestJob.new(strategy: "oai", file_name: "george_grey.rb") }

  describe "#parser" do
    let(:parser) {mock(:parser)}

    it "finds the parser by path" do
      Parser.should_receive(:find).with('oai-george_grey.rb').and_return(parser)
      job.parser.should eq parser
    end
  end

end
