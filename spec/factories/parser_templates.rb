# Read about factories at https://github.com/thoughtbot/factory_bot
FactoryBot.define do
  factory :parser_template do
    name    { Faker::Name.first_name }
    content 'hello'

    trait :deleted do
      deleted_at DateTime.now
    end
  end
end
