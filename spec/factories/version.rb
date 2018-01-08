# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

FactoryBot.define do
  factory :version do
    message   "new test version"
    tags      nil
    user_id   "577d8c270403714b67000001"
    content   "default: \"Research papers for 1\"\r\n\t  attributes :display_collection, :primary_collection,   default: \"Massey Research Online"

    after(:build) do
      
    end

    trait :santos do
      tags ['santos clause']
    end

    trait :production do
      tags ['production']
      content "version for production"
    end

    trait :staging do
      tags ['staging']
      content  "version for staging"
    end
  end
end
