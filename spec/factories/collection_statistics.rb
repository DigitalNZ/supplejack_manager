# frozen_string_literal: true

FactoryBot.define do
  factory :collection_statistics do
    source_id 'nz-history'
    day Time.zone.today.to_s
    suppressed_count 1
    deleted_count 0
    activated_count 0
    suppressed_records []
    deleted_records []
    activated_records []
  end
end
