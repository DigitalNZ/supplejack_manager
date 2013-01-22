class Harvester

  attr_accessor :parser, :limit
  attr_accessor :start_time, :end_time, :records_harvested
  
  def initialize(parser, limit=nil)
    @parser = parser
    @limit = limit.to_i > 0 ? limit.to_i : nil
    @records_harvested = 0
  end

  def start
    @start_time = Time.now

    parser.load
    records = parser.loader.parser_class.records(limit: limit)
    records.each do |record|
      self.post_to_api(record)
    end

    @end_time = Time.now
  end

  def post_to_api(record)
    begin
      attributes = record.attributes
      RestClient.post "#{ENV["API_HOST"]}/harvester/records.json", {record: attributes}.to_json, :content_type => :json, :accept => :json
      @records_harvested += 1
    rescue StandardError => e
      Rails.logger.info "Harvest Error: #{e.message}"
    end
  end

  def elapsed_time
    (start_time - end_time).round(3)
  end

  def records_per_second
    (records_harvested.to_f/elapsed_time.to_f).round(3)
  end
end