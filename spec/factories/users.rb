FactoryBot.define do
  factory :user do
    name      'John Doe'
    email     'john@example.com'
    password  'secret'
    password_confirmation 'secret'
    role 'user'
    manage_link_check_rules true

    trait :admin do
      role 'admin'
    end
  end
end
