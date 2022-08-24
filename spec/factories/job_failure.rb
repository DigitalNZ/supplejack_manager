# frozen_string_literal: true

FactoryBot.define do
  factory :job_failure, class: 'OpenStruct' do
    message { 'Error message' }
    exception_class { 'StandardError' }
    backtrace { ['file_1[1]', 'file_2[10]'] }
  end
end
