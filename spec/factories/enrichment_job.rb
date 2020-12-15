# frozen_string_literal: true

FactoryBot.define do
  factory :enrichment_job do
    id { 1 }
    start_time { Time.zone.now - 1.day }
    end_time { Time.zone.now }
    records_count { 10 }
    throughput { 1.0 }
    duration { 2.0 }
    status { 'started' }
    user_id { 'user_id' }
    parser_id { 'parser_id' }
    version_id { 'version_id' }
    harvest_schedule_id { 'harvest_schedule_id' }
    environment { 'test' }
    failed_records_count { 0 }
    invalid_records_count { 0 }
    posted_records_count { 0 }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    enrichment { 'enrichment_code' }
    record_id { 1 }
    last_posted_record_id { 'last posted record id' }

    trait :finished do
      status { 'finished' }
    end

    trait :stopped do
      status { 'stopped' }
    end

    trait :failed do
      status { 'failed' }
    end
  end
end
