# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :source do
    sequence(:name) {|n| "A Source #{n}" }
    sequence(:source_id) {|n| "source_#{n}"}
    partner
  end
end
