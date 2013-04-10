class EnrichmentJob < AbstractJob
  
  schema do
    attribute :start_time,            :datetime
    attribute :end_time,              :datetime
    attribute :records_count,         :integer
    attribute :throughput,            :float
    attribute :duration,              :float
    attribute :status,                :string
    attribute :user_id,               :string
    attribute :parser_id,             :string
    attribute :version_id,            :string
    attribute :harvest_schedule_id,   :string
    attribute :environment,           :string
    attribute :failed_records_count,  :integer
    attribute :invalid_records_count, :integer
    attribute :posted_records_count,  :integer
    attribute :created_at,            :datetime
    attribute :enrichment,            :string
  end

  include ActiveResource::SchemaTypes

end