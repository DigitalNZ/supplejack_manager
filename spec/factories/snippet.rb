FactoryBot.define do
  factory :snippet do
    name      { Faker::Name.first_name }
    content   { 'module Copyright; end' }
  end
end
