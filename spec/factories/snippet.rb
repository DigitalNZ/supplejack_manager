FactoryBot.define do
  factory :snippet do
    name      { Faker::Name.first_name }
    content   'module Copyright; end'

    trait :deleted do
      deleted_at DateTime.now
    end
  end
end
