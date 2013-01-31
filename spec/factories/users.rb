FactoryGirl.define do
  factory :user do
    name      "John Doe"
    email     "john@boost.co.nz"
    password  "secret"
    password_confirmation "secret"
  end
end
