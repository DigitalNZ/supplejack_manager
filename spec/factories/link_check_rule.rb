# frozen_string_literal: true

FactoryBot.define do
  factory :link_check_rule do
    source_id { 'source_id' }
    xpath { 'xx' }
    status_codes { 'status_codes' }
    active { false }
    throttle { 1 }
  end
end
