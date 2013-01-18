namespace :harvester do
  desc "Task to initiate a new harverst"
  task :start, [:strategy, :file_name, :limit] => :environment do |t, args|
    parser = Parser.find("#{args[:strategy]}-#{args[:file_name]}")
    parser.load

    start_time = Time.now
    puts "[#{start_time}] Starting #{args[:file_name]} harvester."
    records_harvested = 0

    limit = args[:limit].to_i

    klass = parser.loader.parser_class
    records = klass.records(limit: limit > 0 ? limit : nil)
    records.each do |record|
      RestClient.post "#{ENV["API_HOST"]}/harvester/records.json", {record: record.attributes}.to_json, :content_type => :json, :accept => :json
      records_harvested += 1
    end

    elapsed_time = Time.now-start_time
    puts "[#{Time.now}] #{records_harvested} records harvested. Records/sec: #{records_harvested.to_f/elapsed_time.to_f}. (Elapsed: #{elapsed_time} sec.)"
  end
end