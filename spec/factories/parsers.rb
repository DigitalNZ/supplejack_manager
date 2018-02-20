# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

FactoryBot.define do
  factory :parser do
    name      'NZMuseums'
    strategy  'xml'
    content   'class NZMuseums; end'
    data_type 'record'

    trait :enrichment do
      content 'class NZMuseums
        enrichment :test_enrich, priority: -1, required_for_active_record: false do
          requires :enrich_url do
            primary[:landing_url].first
          end

          format :html
          url "#{requirements[:enrich_url]}"
          attribute :tag, default: "enrich test potato"
        end
      end'
    end
  end
end
