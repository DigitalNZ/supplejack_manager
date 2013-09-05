# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :source do
    sequence(:name) {|n| "source #{n}" }
    sequence(:source_id) {|n| "source-id-#{n}" }
    partner
  end
end
