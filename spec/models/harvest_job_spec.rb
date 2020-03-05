require 'rails_helper'

RSpec.describe HarvestJob do
  let(:user) { create(:user, id: 333) }
  let(:job)  { HarvestJob.new(user_id: '1234567', parser_id: '7654321') }

  describe '.from_parser' do
    let(:parser) do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      build(:parser, id: 1234)
    end

    it 'initializes a new HarvestJob' do
      job = HarvestJob.from_parser(parser)
      expect(job.parser_id).to eq 1234
    end

    it 'sets the user_id' do
      job = HarvestJob.from_parser(parser, user)
      expect(job.user_id).to eq 333
    end
  end

  describe ".build" do
    it "initializes a new HarvestJob with default attributes" do
      job = HarvestJob.build
      [:parser_id, :limit, :user_id, :version_id, :environment].each do |attribute|
        expect(job.send(attribute)).to be_nil
      end
    end

    it "overrides the attributes passed" do
      job = HarvestJob.build(parser_id: "12345")
      expect(job.parser_id).to eq "12345"
    end
  end

  describe ".search" do
    let(:jobs) { [job] }

    before(:each) do
      allow(HarvestJob).to receive(:find) { jobs }
    end

    context "environment defined" do
      it "finds all active harvest jobs" do
        pending
        expect(HarvestJob).to receive(:find).with(:all, params: {status: "active", page: 1, environment: ["staging", "production"]})
        HarvestJob.search
      end

      it "finds all finished harvest jobs" do
        pending
        expect(HarvestJob).to receive(:find).with(:all, params: {status: "finished", page: 1, environment: ["staging", "production"]})
        HarvestJob.search("status" => "finished")
      end

      it "paginates through the records" do
        pending
        expect(HarvestJob).to receive(:find).with(:all, params: {status: "finished", page: "2", environment: ["staging", "production"]})
        HarvestJob.search("status" => "finished", "page" => "2")
      end

      it "does not change the workers site and key" do
        pending
        expect(HarvestJob).not_to receive(:change_worker_env!)
        HarvestJob.search("status" => "finished", "page" => "2")
      end
    end

    it "changes the HarvestJob's site and key to the staging site and key" do
      pending
      expect(HarvestJob).to receive(:change_worker_env!).with('staging')
      HarvestJob.search({"status" => "finished", "page" => "2"}, 'staging')
    end

    it "finds parser if provided" do
      pending
      expect(HarvestJob).to receive(:find).with(:all, params: {status: "finished", page: "2", environment: ["staging", "production"], parser_id: "123"})
      HarvestJob.search({"status" => "finished", "page" => "2", "parser" => "123"}, 'staging')
    end
  end

  describe "#user" do
    it "finds the user based on the user_id" do
      expect(User).to receive(:find).with("1234567")
      job.user
    end

    it "returns nil when not found" do
      expect(job.user).to be_nil
    end

    it "returns nil when no user_id is present" do
      job = HarvestJob.new
      expect(job.user).to be_nil
    end
  end

  describe "#parser" do
    it "finds the parser based on the parser_id" do
      expect(Parser).to receive(:find).with("7654321")
      job.parser
    end

    it "returns nil when not found" do
      expect(job.parser).to be_nil
    end

    it "returns nil when no parser_id is present" do
      job = HarvestJob.new
      expect(job.parser).to be_nil
    end
  end

  describe "#finished?" do
    it "returns true" do
      job.status = 'finished'
      expect(job.finished?).to be true
    end

    it "returns false" do
      job.status = 'active'
      expect(job.finished?).to be false
    end
  end

  describe "#total_errors_count" do
    it "should add the failed and invalid record counts" do
      allow(job).to receive(:failed_records_count) { 5 }
      allow(job).to receive(:invalid_records_count) { 3 }
      expect(job.total_errors_count).to eq 8
    end
  end

end
