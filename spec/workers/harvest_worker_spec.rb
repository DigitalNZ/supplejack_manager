require "spec_helper"

describe HarvestWorker do
  let(:worker) { HarvestWorker.new }
  let(:parser) { Parser.new(strategy: "xml", name: "Natlib Pages", content: "class NatlibPages < HarvesterCore::Xml::Base; end") }
  let(:job) { HarvestJob.new }

  before(:each) do
    RestClient.stub(:post)
    parser.load_file
  end
  
  describe "#perform" do
    let(:record) { mock(:record, attributes: {}) }

    before(:each) do
      HarvestJob.stub(:find) { job }

      job.stub(:parser) { parser }
      NatlibPages.stub(:records) { [record] }
    end

    it "fetches the harvest_job from the database" do
      HarvestJob.should_receive(:find).with(1)
      worker.perform(1)
    end

    it "updates record as started" do
      worker.should_receive(:update_as_started).with(job)
      worker.perform(1)
    end

    it "gets records from parser class" do
      NatlibPages.should_receive(:records)
      worker.perform(1)
    end

    it "processes each record" do
      worker.should_receive(:process_record).with(record, job)
      worker.perform(1)
    end

    it "records the end time" do
      worker.perform(1)
      job.end_time.should_not be_nil
    end

    it "rescues exceptions from records method and adds them to job errors" do
      NatlibPages.stub(:records).and_raise "Everything broke"
      worker.perform(1)
      job.harvest_job_errors.first.message.should eq "Everything broke"
    end
  end

  describe "#update_as_started" do
    it "records the start time" do
      time = Time.now
      Timecop.freeze(time) do
        worker.update_as_started(job)
        job.start_time.to_i.should eq time.to_i
      end
    end

    it "saves the job" do
      job.should_receive(:save)
      worker.update_as_started(job)
    end
  end


  describe "#process_record" do
    let(:record) { mock(:record, attributes: {title: "Hi"}) }

    it "posts the record to the api" do
      worker.should_receive(:post_to_api).with(record)
      worker.process_record(record, job)
    end
    
    it "increments records_harvested" do
      worker.process_record(record, job)
      job.records_harvested.should eq 1
    end

    it "saves the job" do
      job.should_receive(:save)
      worker.process_record(record, job)
    end

    it "rescues exceptions from a record and adds it to the job errors" do
      worker.stub(:post_to_api).and_raise "Post failed"
      worker.process_record(record, job)
      job.harvest_job_errors.first.message.should eq "Post failed"
    end
  end

  describe "#post_to_api" do
    let(:record) { mock(:record, attributes: {title: "Hi"}) }

    it "should post to the API" do
      RestClient.should_receive(:post).with("#{ENV["API_HOST"]}/harvester/records.json", {record: {title: "Hi"}}.to_json, :content_type => :json, :accept => :json)
      worker.post_to_api(record)
    end
  end

  describe "#update_as_finished" do
    it "records the end time" do
      time = Time.now
      Timecop.freeze(time) do
        worker.update_as_finished(job)
        job.end_time.to_i.should eq time.to_i
      end
    end

    it "saves the job" do
      job.should_receive(:save)
      worker.update_as_finished(job)
    end
  end

  describe "#stop_harvest?" do
    
    context "stop is true" do
      let(:job) { HarvestJob.create(stop: true) }

      it "returns true" do
        worker.stop_harvest?(job).should be_true
      end

      it "updates the job with the end time" do
        worker.should_receive(:update_as_finished).with(job)
        worker.stop_harvest?(job)
      end

      it "returns true true when more 5 errors" do
        6.times { job.harvest_job_errors.create(message: "Hi") }
        worker.stop_harvest?(job).should be_true
      end
    end

    context "stop is false" do
      let(:job) { HarvestJob.create(stop: false) }

      it "returns true true when more 5 errors" do
        6.times { job.harvest_job_errors.create(message: "Hi") }
        worker.stop_harvest?(job).should be_true
      end

      it "returns false" do
        worker.stop_harvest?(job).should be_false
      end
    end

  end
end
