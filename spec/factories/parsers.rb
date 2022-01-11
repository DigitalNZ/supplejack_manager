# frozen_string_literal: true

FactoryBot.define do
  factory :parser do
    name      { Faker::Name.first_name }
    strategy  { 'xml' }
    content   { "class NZMuseums < SupplejackCommon::Xml::Base
      %r{#{Faker::Name.last_name}}
    end" }
    data_type { 'record' }
    message { 'test message' }
    source

    trait :enrichment do
      name    { 'NZMuseums' }
      content { 'class NZMuseums < SupplejackCommon::Xml::Base
        enrichment :test_enrich, priority: -1, required_for_active_record: false do
          requires :enrich_url do
            primary[:landing_url].first
          end

          format :html
          url "#{requirements[:enrich_url]}"
          attribute :tag, default: "enrich test potato"
        end
      end' }
    end
  end
end
