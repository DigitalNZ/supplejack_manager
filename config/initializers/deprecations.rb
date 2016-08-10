# frozen_string_literal: true
module Rack
  # Overwriting Rack file for deprecations
  # Can be remove when upgrade to Rails new versions
  class File
    # Returns error/deprecations to console on test.
    #
    # @author Yar
    # @last_modified Yar
    # @param * []
    # @return [String] errors
    def warn(*)
    end
  end
end
