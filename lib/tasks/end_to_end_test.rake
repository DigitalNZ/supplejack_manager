# frozen_string_literal: true

namespace :end_to_end_test do
  desc 'Set up required for end to end testing on the Manager'

  task purge: :environment do
    p 'Deleting User..'

    user = User.where(email: 'endtoendtest@email.com').first

    user&.destroy!

    p 'Deleting Partner..'

    partner = Partner.where(name: 'End to End Test').first

    partner&.destroy!

    p 'Deleting Source..'

    source = Source.where(source_id: 'end_to_end_test').first

    source&.destroy!

    p 'Deleting Parser..'

    parser = Parser.where(name: 'End to end test harvest').first

    parser&.destroy!
  end

  desc 'Load the data required for the end to end test'
  task :seed, [:api_host, :api_key] => [:environment] do |_t, args|
    p 'Creating end to end test user..'

    user = User.create(email: 'endtoendtest@email.com', name: 'End to End test user', password: 'password', password_confirmation: 'password', role: 'admin')

    p 'Creating partner..'

    partner = Partner.find_or_create_by(name: 'End to End Test')

    p 'Creating source..'
    source = Source.find_or_create_by(partner_id: partner.id, source_id: 'end_to_end_test')

    p 'Creating Parser..'

    API_HOST = args[:api_host] || 'http://localhost:3000'
    API_KEY = args[:api_key] || 'richardkey'

    Parser.create(name: 'End to end test harvest', strategy: 'json',
    content: "class EndToEndTestHarvest < SupplejackCommon::Json::Base\r\n  \r\n  ################\r\n  #\r\n  # Hardcoded with \r\n  #   - staging api calls (just below and in enrichment)\r\n  #\r\n  #\tTODO\r\n  #\t\t- flesh out other DSL tests (eg .to_date, .truncate, .split, etc) \r\n  #\r\n  # Not tested\r\n  # - delete_if block\r\n  # - \"requires\" functionality in enrich block\r\n  #\r\n  # Needs these 3 records (1 exemplar and 2 fillers)\r\n\t# #{API_HOST}/records.json?&api_key=#{API_KEY}&fields=internal_identifier,title,description,dc_identifier,landing_url,subject,thumbnail_url,large_thumbnail_url,attachments,locations,record_id&order=desc&text=source_id_s%3Apermanent_exemplar\r\n  #\r\n  ######################\r\n  \r\n  # How to use:\r\n  # - run F&F with both enrichments\r\n  # - run normal with 'enrich_test_one'\r\n  # - check this link\r\n  #   #{API_HOST}/records.json?&api_key=#{API_KEY}&fields=internal_identifier,title,description,dc_identifier,landing_url,subject,thumbnail_url,large_thumbnail_url,attachments,locations&order=desc&and[dc_identifier]=testing:123&text=source_id_s%3Apermanent_exemplar+OR+source_id_s%3Aend_to_end_test\r\n  # - 1. Should only be only 2 (almost identical) records (you can tell them apart with the internal_identifier)\r\n  #   2. Check these fields for any differences between the 2 records\r\n  #   \t\t- title,description,dc_identifier,subject,thumbnail_url,large_thumbnail_url,locations\r\n  #   3. Attachments should have only 1 titled A and 1 titled B (2 in total)\r\n  #   4. landing_url should have a record_id\r\n\r\n\r\n  # Tests json pagination\r\n  base_url \"#{API_HOST}/records.json?&api_key=#{API_KEY}&order=desc&text=source_id_s%3Apermanent_exemplar&fields=verbose,attachments,locations,internal_identifier\" \r\n\tpaginate page_parameter: \"page\", per_page_parameter: \"per_page\", per_page: 2, type: \"page\", page: 1, total_selector: \"$..result_count\" \r\n\t\r\n  record_selector \"$..results\"\r\n      \r\n  # These 4 fields are not really needed \r\n  attributes :display_collection,   \t\t\t\tpath: \"display_collection\"\r\n  attributes :primary_collection,   \t\t\t\tpath: \"primary_collection[*]\"\r\n  attributes :content_partner,   \t\t\t\t\t\tpath: \"content_partner[*]\"\r\n  attributes :display_content_partner,   \t\tpath: \"display_content_partner\"\r\n  \r\n  attributes :title,   \t\t\t\t\t\t\t\t\t\t\tpath: \"title\" # testing single value field\r\n  attributes :description,   \t\t\t\t\t\t\t\tpath: \"description\"\r\n  \r\n  attribute  :subject,             \t\t\t\t\tdefault: [\"Added in primary fragment\"] # testing multi value field\r\n  \r\n  attributes :thumbnail_url,   \t\t\t\t\t\t\tdefault: \"http://digitalnz.org/test/correct_thumb.jpg\"\r\n  attributes :large_thumbnail_url,   \t\t\t\tdefault: \"http://digitalnz.org/test/this_thumb_should_not_be_present.jpg\" # to be overwritten\r\n  \r\n  attribute  :landing_url,\t\t\t\t\t\t\t\t\tdefault: \"https://www.digitalnz.org/records/replace_this\" # testing replace this functionality\r\n  \r\n  attributes :internal_identifier do\r\n    timestamp = DateTime.now.strftime(\"%Y%m%dT%H%M\").to_s.chop # removes the last digit of the minute's so that its unique every 10 minutes\r\n    \"end-to-end_exemplar_TEST_record-\#{timestamp}0\"\t\r\n\tend\r\n  \r\n  attribute :attachments do\r\n    [ \r\n      {\r\n        name: \"Attachment A: Added in primary fragment (should only be one A - this one was added \#{DateTime.now})\",\r\n        thumbnail_url: \"http://digitalnz.org/test/correct_thumb.jpg\",\r\n        ndha_rights: 100\r\n        }\r\n      ]\r\n  end\r\n  \r\n  attribute :locations do\r\n    [{\r\n      lat: -41.2574181,\r\n      lng:  174.8606583,\r\n      placename: \"Matiu/Somes Island, Wellington, New Zealand\",\r\n      comment: \"Location provided by Google\"\r\n      }]\r\n  end  \r\n\r\n  reject_if do\r\n    get(:title).find_with(/^Filler/).present?\r\n  end\r\n  \r\n  \r\n  #========================enrichment begins ======================================== \r\n  enrichment :enrich_test_one, priority: -1, required_for_active_record: false do     \r\n\r\n    requires :enrich_url do\r\n      primary[:landing_url].first\r\n    end\r\n    \r\n    format :xml\r\n    \r\n    url \"https://digitalnz.org/\"\r\n\r\n    attribute :subject do\r\n      \"there should only be one of these from enrich_test_one (this one was added \#{DateTime.now}\" \r\n    end \r\n\r\n    \r\n    attribute :attachments do\r\n      [ \r\n        {\r\n          name: \"Attachment B: \#{get(:subject).first})\",\r\n          thumbnail_url: \"http://digitalnz.org/test/correct_thumb.jpg\",\r\n          ndha_rights: 200\r\n          }\r\n        ]\r\n    end\r\n       \r\n  end  \r\n  #========================  enrichment ends  ======================================== \r\n\r\n  #========================enrichment begins ======================================== \r\n  enrichment :enrich_test_two, priority: -1, required_for_active_record: false do     \r\n\r\n      \r\n    format :json\r\n    \r\n    # tests a request from an enrichment\r\n    url \"#{API_HOST}/records.json?&api_key=#{API_KEY}&fields=internal_identifier,title,description,dc_identifier,landing_url,subject,thumbnail_url,large_thumbnail_url,attachments,locations&order=desc&and[dc_identifier]=testing:123&text=source_id_s%3Apermanent_exemplar+OR+source_id_s%3Aend_to_end_test\"\r\n\r\n    attribute :large_thumbnail_url,   \t\t\t\tdefault: \"http://digitalnz.org/test/correct_updated_thumbnail.jpg\" # overwritting single value field\r\n    \r\n    attribute :dc_identifier do\r\n      fetch(\"$..dc_identifier\").first # tests a fetch in an enrich\r\n    end\r\n\r\n  end  \r\n  #========================  enrichment ends  ========================================    \r\n  \r\nend", data_type: "record", allow_full_and_flush: true, last_editor: "End to End test user", source_id: source.id, partner: partner.name, message: 'End to End test from seed', user_id: user.id)

    p 'Complete!'
  end
end
