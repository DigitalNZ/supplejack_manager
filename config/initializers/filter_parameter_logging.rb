# Be sure to restart your server when you modify this file.

# Configure parameters to be filtered from the log file. Use this to limit dissemination of
# sensitive information. See the ActiveSupport::ParameterFilter documentation for supported
# notations and behaviors.
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn,
  :password,
  :password_confirmation,
  :otp_attempt,
  :parser_code,
  :raw_data,
  :harvested_attributes,
  :harvest_failure,
  :enrichment_failures,
  :api_record,
  :content,
]
