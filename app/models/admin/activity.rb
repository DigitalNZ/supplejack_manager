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
      response = Api::Activity.index(environment)
      JSON.parse(response)['site_activities']
    rescue Errno::ECONNREFUSED
      []
    end
  end
end
