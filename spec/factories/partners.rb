
# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :partner do
    sequence(:name) {|n| "Partner #{n}" }
  end
end
