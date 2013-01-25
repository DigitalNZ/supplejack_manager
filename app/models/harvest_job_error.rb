class HarvestJobError
  include Mongoid::Document
  include Mongoid::Timestamps

  field :exception_class, type: String
  field :message,         type: String
  field :backtrace,       type: Array

  embedded_in :harvest_job

end
