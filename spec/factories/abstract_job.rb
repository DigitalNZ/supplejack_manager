# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# Status can be
# finished, failed, stopped, ready

FactoryBot.define do
  factory :abstract_job do
    id SecureRandom.hex
    start_time 1.day.ago
    end_time Time.zone.now
    processed_count 0
    records_count 0
    throughput 0
    duration 0
    status 'ready'
    environment 'staging'
    status_message 'status_message'
    user_id 'user_id'
    parser_id 'parser_id'
    version_id 'version_id'
    harvest_schedule_id 'harvest_schedule_id'
    failed_records_count 0
    invalid_records_count 0
    incremental false
    enrichments 'enrichment code'
  end
end
