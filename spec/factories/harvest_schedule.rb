# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

FactoryGirl.define do
  factory :harvest_schedule do
    start_time Time.zone.now
    end_time Time.zone.now
    records_count 22
    throughput 2.1724137931034484
    duration 29
    status 'finished'
    status_message nil
    environment 'staging'
  end
end
