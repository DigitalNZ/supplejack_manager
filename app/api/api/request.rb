# frozen_string_literal: true

module Api
  class Request
    include EnvironmentHelpers

    attr_reader :url, :token, :params

    def initialize(path, env, params = {})
      @url = "#{fetch_env_vars(env)['API_HOST']}#{path}.json"
      @token = fetch_env_vars(env)['HARVESTER_API_KEY']
      @params = params
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
        if method.in?(%i[post put patch])
          payload = @params
          url_params = {}
        else
          payload = nil
          url_params = @params.any? ? { params: @params } : {}
        end

        RestClient::Request.execute(
          method:,
          url: @url,
          payload:,
          headers: {
            'Authentication-Token': @token
          }.merge(url_params)
        )
      end
  end
end
