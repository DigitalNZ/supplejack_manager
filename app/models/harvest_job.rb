class HarvestJob < ActiveResource::Base
  
  self.site = ENV["WORKER_HOST"]
  self.user = ENV["WORKER_API_KEY"]

  def self.from_parser(parser, user=nil)
    self.new(parser_id: parser.id, limit: nil, user_id: user.try(:id))
  end

  def user
    User.find(self.user_id)
  end

  def finished?
    !!end_time
  end

  def start_time
    value = super
    if value.is_a?(String)
      value = value.present? ? Time.parse(value) : nil
    end
    value
  end

  def end_time
    value = super
    if value.is_a?(String)
      value = value.present? ? Time.parse(value) : nil
    end
    value
  end
end