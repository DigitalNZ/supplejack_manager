
FactoryBot.define do
  factory :harvest_schedule do
    start_time { Time.zone.now }
    end_time { Time.zone.now }
    records_count { 22 }
    throughput { 2.1724137931034484 }
    duration { 29 }
    status { 'finished' }
    status_message { nil }
    environment { 'staging' }
  end
end
