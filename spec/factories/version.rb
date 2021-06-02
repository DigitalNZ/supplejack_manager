# frozen_string_literal: true

FactoryBot.define do
  factory :version do
    message   { 'new test version' }
    tags      { nil }
    user_id   { '577d8c270403714b67000001' }
    content   { 'class NZMuseums; end' }

    user

    trait :santos do
      tags { ['santos clause'] }
    end

    trait :production do
      tags { ['production'] }
      content { 'version for production' }
    end

    trait :staging do
      tags { ['staging'] }
      content { 'version for staging' }
    end

    trait :enrichment do
      content { 'class NZMuseums < SupplejackCommon::Xml::Base
      base_url "http://www.newshub.co.nz/home/new-zealand.include.L2NvbnRlbnQvbmV3c2h1Yi9iZWx0cy9zaW5nbGUvbnovbGF0ZXN0L2pjcjpjb250ZW50L2JlbHQuZGlyZWN0RHJhdw==.html" #testing schedule
        #paginate page_parameter: "page", type: "page", per_page_parameter: "max-results", page: 1, per_page: 40, total_selector: "string(90)"
        record_selector "//section/div[@class=\'Story-item\']"
        record_format :html

        include_snippet "Global validations"

        throttle :host => "www.newshub.co.nz", :delay => 0.5

        attributes :content_partner, :creator,:display_content_partner, default: "TV3"
        attributes :primary_collection, :display_collection, default: "Newshub"
        attributes :usage, :copyright, default: "All rights reserved"

        attribute  :title, xpath: "/a[@class=\'Story-link\']//h2"
        attribute  :description, xpath: "/a[@class=\'Story-link\']//p"

        attribute :landing_url do
          fetch("/a[@class=\'Story-link\']/@href").first
        end

        attribute :internal_identifier do
          get(:landing_url).downcase
        end

        attribute :thumbnail_url do
          fetch("//img[1]/@srcset")
        end

        attribute :large_thumbnail_url do
          get(:thumbnail_url).mapping(/.360.q75/ => ".720.q40")
        end

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
