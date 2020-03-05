# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "john#{n}@example.com" }
    name      { 'John Doe' }
    password  { 'secret' }
    password_confirmation { 'secret' }
    role { 'user' }
    manage_link_check_rules { true }

    trait :admin do
      role { 'admin' }
    end
  end
end
