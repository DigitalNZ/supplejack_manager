require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'features/cassettes'
  c.ignore_hosts '127.0.0.1', 'localhost'
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr-global', :record => :new_episodes # uses default record mode since no options are given
  t.tags '@disallowed_1', '@disallowed_2', :record => :none
  t.tag  '@vcr', use_scenario_name: true, record: :new_episodes, serialize_with: :json # Using vcr-json to store the http interactions in a json file to deal with yaml encoding issues
end
