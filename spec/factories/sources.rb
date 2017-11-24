# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :source do
    sequence(:name) {|n| "source #{n}" }
    sequence(:source_id) {|n| "source_#{n}"}
    partner
  end
end
