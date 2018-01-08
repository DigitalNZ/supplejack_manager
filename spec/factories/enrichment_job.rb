# frozen_string_literal: true

FactoryBot.define do
  factory :enrichment_job do
    start_time Time.zone.now - 1.day
    end_time Time.zone.now
    records_count 10
    throughput 1.0
    duration 2.0
    status 'started'
  end
end
