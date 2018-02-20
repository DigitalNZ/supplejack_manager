# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :parser_template do
    name      { Faker::Name.first_name }
    content 'hello'
  end
end
