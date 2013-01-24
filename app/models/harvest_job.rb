class HarvestJob
  include Mongoid::Document
  include Mongoid::Timestamps

  field :parser_path,         type: String
  field :version,             type: String

  field :start_time,          type: DateTime
  field :end_time,            type: DateTime

  field :records_harvested,   type: Integer
  field :average_record_time, type: Float

  belongs_to :user

  after_create :enqueue

  def enqueue
    HarvestWorker.perform_async(self.id)
  end

  def parser
    Parser.find(self.parser_path)
  end
end
