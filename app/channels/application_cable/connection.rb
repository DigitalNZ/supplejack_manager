# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      # This is a websocket so we have no warden and no session here
      # How to reuse the login made with devise?
      # http://www.rubytutorial.io/actioncable-devise-authentication/
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        if verified_user = env['warden'].user
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
