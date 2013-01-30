class HarvestJob < ActiveResource::Base
  self.site = ENV["WORKER_HOST"]

  def self.from_parser(parser)
    self.new(parser_id: parser.id)
  end

  def user
    User.find(self.user_id)
  end

  def finished?
    !!end_time
  end
end