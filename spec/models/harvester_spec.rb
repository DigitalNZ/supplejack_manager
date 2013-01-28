require "spec_helper"

describe Harvester do

  let(:parser) { Parser.new(strategy: "xml", name: "Natlib Pages", content: "class NatlibPages < HarvesterCore::Xml::Base; end") }
  let(:harvester) { Harvester.new(parser, "10") }

  before(:each) do
    RestClient.stub(:post)
    parser.load_file
  end

  describe "#start" do
    let(:record) { mock(:record, attributes: {}) }

    before(:each) do
      NatlibPages.stub(:records) { [record] }
    end

    it "records the start_time" do
      time = Time.now
      Timecop.freeze(time) do
        harvester.start
        harvester.start_time.to_i.should eq time.to_i
      end
    end

    it "fetches the records with a limit" do
      NatlibPages.should_receive(:records).with(limit: 10)
      harvester.start
    end

    it "fetches the records without a limit" do
      harvester = Harvester.new(parser, "")
      NatlibPages.should_receive(:records).with(limit: nil)
      harvester.start
    end

    it "posts each record to the API" do
      harvester.should_receive(:post_to_api).with(record)
      harvester.start
    end

    it "records the end_time" do
      harvester.start
      harvester.end_time.should_not be_nil
    end
  end

  describe "post_to_api" do
    let(:record) { mock(:record, attributes: {title: "Hi"}) }

    it "should post to the API" do
      RestClient.should_receive(:post).with("#{ENV["API_HOST"]}/harvester/records.json", {record: {title: "Hi"}}.to_json, :content_type => :json, :accept => :json)
      harvester.post_to_api(record)
    end

    it "recovers from a rest client exception" do
      RestClient.should_receive(:post).and_raise(StandardError.new("Error"))
      harvester.post_to_api(record)
    end
  end
end