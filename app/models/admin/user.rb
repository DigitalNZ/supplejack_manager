# frozen_string_literal: true

# This user is pulled from Supplejack API
# For displaying within the admin section of the Manager

module Admin
  # app/models/admin/user.rb
  class User < ActiveResource::Base
    self.site = 'http://localhost:3000/harvester'

    class << self
      def collection_path(prefix_options = {}, query_options = {})
        super(prefix_options, query_options.merge(api_key: api_key))
      end

      def element_path(id, prefix_options = {}, query_options = {})
        super(id, prefix_options, query_options.merge(api_key: api_key))
      end

      def api_key
        APPLICATION_ENVIRONMENT_VARIABLES['development']['HARVESTER_API_KEY']
      end
    end
  end
end
