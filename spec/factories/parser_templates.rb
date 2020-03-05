# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :parser_template do
    name    { Faker::Name.first_name }
    content { 'hello' }
  end
end
