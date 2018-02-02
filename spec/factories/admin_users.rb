# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user, class: 'Admin::User' do
    username 'richard'
    name     'richard'
    authentication_token 'oUSURsQWvvzNDU6yxzjH'
    email 'richard@boost.co.nz'
    role 'admin'
    daily_requests 288
    monthly_requests 0
    max_requests 1000
  end
end
