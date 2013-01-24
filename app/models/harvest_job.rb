class HarvestJob
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_name,           type: String
  field :strategy,            type: String
  field :version,             type: String

  field :start_time,          type: DateTime
  field :end_time,            type: DateTime

  field :records_harvested,   type: Integer, default: 0
  field :average_record_time, type: Float

  embeds_many :harvest_job_errors

  belongs_to :user

  after_create :enqueue

  def enqueue
    HarvestWorker.perform_async(self.id)
  end

  def parser
    Parser.find("#{strategy}-#{file_name}")
  end
end
