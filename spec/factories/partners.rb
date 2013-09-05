# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :partner do
    sequence(:name) {|n| "Partner #{n}" }
  end
end
