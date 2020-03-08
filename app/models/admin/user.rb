# frozen_string_literal: true

# This user is pulled from Supplejack API
# For displaying within the admin section of the Manager

module Admin
  # app/models/admin/user.rb
  class User
    attr_accessor :environment, :page

    def initialize(environment)
      @environment = environment
    end

    def all
      @users = JSON.parse(RestClient.get("#{host}/harvester/users.json", params: { api_key: api_key }))['users']
    rescue Errno::ECONNREFUSED
      []
    end

    def find(id)
      @user = JSON.parse(RestClient.get("#{host}/harvester/users/#{id}.json", params: { api_key: api_key, page: page }))
    end

    def update(params)
      RestClient.patch("#{host}/harvester/users/#{params['id']}.json?api_key=#{api_key}", { user: { max_requests: params['max_requests'] } })
    end

    private
      def host
        APPLICATION_ENVIRONMENT_VARIABLES[environment]['API_HOST']
      end

      def api_key
        APPLICATION_ENVIRONMENT_VARIABLES[environment]['HARVESTER_API_KEY']
      end
  end
end
