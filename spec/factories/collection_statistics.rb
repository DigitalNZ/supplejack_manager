# frozen_string_literal: true

FactoryBot.define do
  factory :collection_statistics do
    source_id { 'nz-history' }
    day { '2022-03-16' }
    suppressed_count { 1 }
    deleted_count { 0 }
    activated_count { 0 }
    suppressed_records { [] }
    deleted_records { [] }
    activated_records { [] }
  end
end
