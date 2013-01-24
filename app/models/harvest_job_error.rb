class HarvestJobError
  include Mongoid::Document
  include Mongoid::Timestamps

  field :exception_class, type: String
  field :message,         type: String
  field :backtrace,       type: Array

end
