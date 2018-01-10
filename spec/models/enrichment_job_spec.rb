# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EnrichmentJob do
  let(:enrichment_job) { build(:enrichment_job) }

  describe '#attributes' do
    it 'has a start time' do
      expect(enrichment_job.start_time).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'has an end_time' do
      expect(enrichment_job.end_time).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'has a records_count' do
      expect(enrichment_job.records_count).to eq 10
    end

    it 'has throughput' do
      expect(enrichment_job.throughput).to eq 1.0
    end

    it 'has a duration' do
      expect(enrichment_job.duration).to eq 2.0
    end

    it 'has a status' do
      expect(enrichment_job.status).to eq 'started'
    end

    it 'has a user_id' do
      expect(enrichment_job.user_id).to eq 'user_id'
    end

    it 'has a parser_id' do
      expect(enrichment_job.parser_id).to eq 'parser_id'
    end

    it 'has a version_id' do
      expect(enrichment_job.version_id).to eq 'version_id'
    end

    it 'has a harvest_schedule_id' do
      expect(enrichment_job.harvest_schedule_id).to eq 'harvest_schedule_id'
    end

    it 'has an environment' do
      expect(enrichment_job.environment).to eq 'test'
    end

    it 'has a failed_records_count' do
      expect(enrichment_job.failed_records_count).to eq 0
    end

    it 'has a invalid_records_count' do
      expect(enrichment_job.invalid_records_count).to eq 0
    end

    it 'has a posted_records_count' do
      expect(enrichment_job.posted_records_count).to eq 0
    end

    it 'has a created_at' do
      expect(enrichment_job.created_at).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'has an enrichment' do
      expect(enrichment_job.enrichment).to eq 'enrichment_code'
    end

    it 'has a record_id' do
      expect(enrichment_job.record_id).to eq 1
    end
  end
end
