# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  password_confirmation
  otp_attempt
  parser_code
  raw_data
  harvested_attributes
  harvest_failure
  enrichment_failures
  api_record
  content
]
