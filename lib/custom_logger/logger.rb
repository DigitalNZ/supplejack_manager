# frozen_string_literal: true

unless Rails.env.test?
  module ActiveSupport
    module TaggedLogging
      module Formatter
        def call(severity, time, progname, data)
          data = { msg: data.to_s } unless data.is_a?(Hash)
          tags = current_tags
          data[:tags] = tags if tags.present?
          _call(severity, time, progname, data)
        end
      end
    end
  end
end

module CustomLogger
  class Logger < Ougai::Logger
    include ActiveSupport::LoggerThreadSafeLevel
    include LoggerSilence

    def initialize(*args)
      super
      after_initialize if respond_to? :after_initialize
    end

    def create_formatter
      if Rails.env.development? || Rails.env.test?
        Ougai::Formatters::Readable.new
      else
        Ougai::Formatters::Bunyan.new
      end
    end
  end
end
