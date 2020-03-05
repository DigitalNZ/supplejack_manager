# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :source do
    sequence(:source_id) { |n| "source_#{n}" }
    partner { build(:partner) }
  end
end
