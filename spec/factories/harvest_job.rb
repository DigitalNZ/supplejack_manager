# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_job do
    start_time { Time.zone.now - 1.day }
    end_time { Time.zone.now }
    updated_at { Time.zone.now }
    records_count { 10 }
    throughput { 0 }
    duration { 0 }
    status { 'ready' }
    environment { 'staging' }

    harvest_failure { OpenStruct.new(backtrace: '{}') }
    invalid_records { [] }
    failed_records { [] }

    trait :active do
      id { 1 }
      status { 'active' }
    end

    trait :finished do
      id { 1 }
      status { 'finished' }
    end

    trait :stopped do
      id { 1 }
      status { 'stopped' }
    end

    trait :failed do
      id { 1 }
      status { 'failed' }
    end
  end
end
