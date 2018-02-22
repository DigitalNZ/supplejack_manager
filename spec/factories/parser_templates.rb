# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :parser_template do
    name 'Copyright'
    content 'hello'
    user_id '1'
  end
end
