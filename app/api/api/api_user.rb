# frozen_string_literal: true

module Api
  class ApiUser < Request
    def self.index(env)
      Api::Request.new(
        '/harvester/users',
        env
      ).get
    end

    def self.get(env, user_id, params)
      Api::Request.new(
        "/harvester/users/#{user_id}",
        env,
        params
      ).get
    end

    def self.patch(env, user_id, params)
      Api::Request.new(
        "/harvester/users/#{user_id}",
        env,
        params
      ).patch
    end
  end
end
