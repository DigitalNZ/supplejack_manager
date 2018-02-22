FactoryBot.define do
  factory :parser do
    name      Faker::Company.name
    strategy  'xml'
    content   'class NZMuseums; end'
    data_type 'record'
  end
end
