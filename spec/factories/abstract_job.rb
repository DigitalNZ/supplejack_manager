
# Status can be
# finished, failed, stopped, ready

FactoryBot.define do
  factory :abstract_job do
    id { SecureRandom.hex }
    start_time { 1.day.ago }
    end_time { Time.zone.now }
    processed_count { 0 }
    records_count { 0 }
    throughput { 0 }
    duration { 0 }
    status { 'ready' }
    environment { 'staging' }
    status_message { 'status_message' }
    user_id { 'user_id' }
    parser_id { 'parser_id' }
    version_id { 'version_id' }
    harvest_schedule_id { 'harvest_schedule_id' }
    failed_records_count { 0 }
    invalid_records_count { 0 }
    incremental { false }
    enrichments { 'enrichment code' }
    last_posted_record_id { 'last posted record id' }
    updated_at { Time.zone.now }
  end
end
