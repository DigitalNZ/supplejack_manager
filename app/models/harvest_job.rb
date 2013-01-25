class HarvestJob
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_name,           type: String
  field :strategy,            type: String
  field :version,             type: String
  field :limit,               type: Integer, default: 0

  field :start_time,          type: DateTime
  field :end_time,            type: DateTime

  field :records_harvested,   type: Integer, default: 0
  field :average_record_time, type: Float
  field :stop,                type: Boolean, default: false

  embeds_many :harvest_job_errors

  belongs_to :user

  after_create :enqueue

  def self.from_parser(parser)
    new(strategy: parser.strategy, file_name: parser.name)
  end

  def enqueue
    HarvestWorker.perform_async(self.id)
  end

  def parser
    Parser.find("#{strategy}-#{file_name}")
  end

  def finished?
    !!end_time
  end
end
