# frozen_string_literal: true

module Api
  class Activity < Request
    def self.index(env)
      Api::Request.new(
        '/harvester/activities',
        env
      ).get
    end
  end
end
