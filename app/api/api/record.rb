# frozen_string_literal: true

module Api
  class Record < Request
    def self.get(env, record_id)
      Api::Request.new("/harvester/records/#{record_id}", env).get
    end

    def self.put(env, record_id, params)
      Api::Request.new("/harvester/records/#{record_id}", env, params).put
    end
  end
end
