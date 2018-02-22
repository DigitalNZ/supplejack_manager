FactoryBot.define do
  factory :version do
    message   'new test version'
    tags      nil
    user_id   '577d8c270403714b67000001'
    content   'default: \"Research papers for 1\"\r\n\t  attributes :display_collection, :primary_collection,   default: \"Massey Research Online'
    
    trait :santos do
      tags ['santos clause']
    end

    trait :production do
      tags ['production']
      content 'version for production'
    end

    trait :staging do
      tags ['staging']
      content 'version for staging'
    end
  end
end
