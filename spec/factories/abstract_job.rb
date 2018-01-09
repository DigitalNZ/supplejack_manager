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
    start_time Time.zone.now - 2.days.ago
    end_time Time.zone.now
    records_count 0
    throughput 0
    duration 0
    status 'ready'
    status_message nil
    user_id nil
    environment 'staging'
  end
end
