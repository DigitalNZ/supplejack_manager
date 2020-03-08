# frozen_string_literal: true

# The admin is pulled from Supplejack API
# For displaying within the admin section of the Manager

module Admin
  # app/models/admin/activity.rb
  class Activity
    attr_accessor :environment

    def initialize(environment)
      @environment = environment
    end

    def all
      JSON.parse(RestClient.get("#{host}/harvester/activities.json", params: { api_key: api_key }))['site_activities']
    rescue Errno::ECONNREFUSED
      []
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
