# frozen_string_literal: true

module Api
  class Source < Request
    def self.index(env, params)
      Api::Request.new('/harvester/sources', env, params).get
    end

    def self.reindex(env, source_id, params)
      Api::Request.new("/harvester/sources/#{source_id}/reindex", env, params).get
    end

    def self.put(env, source_id, params)
      Api::Request.new("/harvester/sources/#{source_id}", env, params).put
    end
  end
end
