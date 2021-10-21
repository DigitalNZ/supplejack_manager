# frozen_string_literal: true

module Api
  class Request
    include EnvironmentHelpers

    attr_reader :url, :token, :params

    def initialize(path, env, params = nil)
      @url = "#{fetch_env_vars(env)['API_HOST']}#{path}.json"
      @token = fetch_env_vars(env)['HARVESTER_API_KEY']
      @params = params ? { params: params } : {}
    end

    def get
      execute(:get)
    end

    def post
      execute(:post)
    end

    def put
      execute(:put)
    end

    def patch
      execute(:patch)
    end

    def delete
      execute(:delete)
    end

    private
      def execute(method)
        RestClient::Request.execute(
          method: method,
          url: @url,
          headers: {
            'Authentication-Token': @token
          }.merge(@params)
        )
      end
  end
end
