# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AbstractJob do
  let(:abstract_job) { build(:abstract_job) }

  describe '#attributes' do
    it 'has a start_time' do
      expect(abstract_job.start_time).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'has an end_time' do
      expect(abstract_job.end_time).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'has a records_count' do
      expect(abstract_job.records_count).to eq 0
    end

    it 'has a processed_count' do
      expect(abstract_job.processed_count).to eq 0
    end

    it 'has throughput' do
      expect(abstract_job.throughput).to eq 0
    end

    it 'has duration' do
      expect(abstract_job.duration).to eq 0
    end

    it 'has status' do
      expect(abstract_job.status).to eq 'ready'
    end

    it 'has status_message' do
      expect(abstract_job.status_message).to eq 'status_message'
    end

    it 'has a user_id' do
      expect(abstract_job.user_id).to eq 'user_id'
    end

    it 'has a parser_id' do
      expect(abstract_job.parser_id).to eq 'parser_id'
    end

    it 'has a version_id' do
      expect(abstract_job.version_id).to eq 'version_id'
    end

    it 'has a harvest_schedule_id' do
      expect(abstract_job.harvest_schedule_id).to eq 'harvest_schedule_id'
    end

    it 'has a failed_records_count' do
      expect(abstract_job.failed_records_count).to eq 0
    end

    it 'has a invalid_records_count' do
      expect(abstract_job.invalid_records_count).to eq 0
    end

    it 'has a incremntal' do
      expect(abstract_job.incremental).to eq false
    end

    it 'has enrichments' do
      expect(abstract_job.enrichments).to eq 'enrichment code'
    end
  end

  describe '#user' do
    let(:user) { create(:user) }
    let(:abstract_job)  { build(:abstract_job, user_id: user) }

    it 'returns the user' do
      expect(abstract_job.user).to eq user
    end
  end

  describe '#parser' do
    before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
    end

    let(:source) { create(:source) }
    let(:parser) { create(:parser, source_id: source) }
    let(:abstract_job) { build(:abstract_job, parser_id: parser) }

    it 'returns the parser' do
      expect(abstract_job.parser).to eq parser
    end
  end

  describe '#harvest_schedule' do
    let(:harvest_schedule) { build(:harvest_schedule) }
    let(:abstract_job)     { build(:abstract_job, harvest_schedule_id: harvest_schedule) }

    it 'returns the harvest_schedule' do
      allow(HarvestSchedule).to receive(:find) { harvest_schedule }
      expect(abstract_job.harvest_schedule).to eq harvest_schedule
    end
  end

  describe '#finished?' do
    let(:finished)   { build(:abstract_job, status: 'finished') }
    let(:unfinished) { build(:abstract_job, status: 'started') }

    it 'returns true when the status is finished' do
      expect(finished.finished?).to eq true
    end

    it 'returns false when the status is not finished' do
      expect(unfinished.finished?).to eq false
    end
  end

  describe '#total_errors_count' do
    let(:total) { build(:abstract_job, failed_records_count: 2, invalid_records_count: 5) }

    it 'returns the total of failed records and invalid records' do
      expect(total.total_errors_count).to eq 7
    end
  end
end
