# frozen_string_literal: true

module Api
  class Partner < Request
    def self.post(env, params)
      Api::Request.new('/harvester/partners', env, params).post
    end
  end
end
