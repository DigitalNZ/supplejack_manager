# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_job do
    start_time Time.zone.now - 1.day
    end_time Time.zone.now
    records_count 10
    throughput 0
    duration 0
    status 'ready'
  end
end
