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
      response = Api::ApiUser.index(environment)
      @users = JSON.parse(response)['users']
    rescue Errno::ECONNREFUSED
      []
    end

    def find(id)
      response = Api::ApiUser.get(environment, id, { page: page })
      @user = JSON.parse(response)
    end

    def update(params)
      Api::ApiUser.patch(environment, params['id'], { user: { max_requests: params['max_requests'] } })
    end
  end
end
