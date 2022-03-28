# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src     :none

  # alphabetically ordered
  policy.base_uri        :none
  policy.connect_src     :self
  policy.img_src         :self, :data, 'https://ajax.googleapis.com'
  policy.font_src        :self
  policy.form_action     :self
  policy.frame_ancestors :none
  policy.object_src      :none
  policy.script_src      :self, :unsafe_inline
  policy.style_src       :self, 'https://ajax.googleapis.com'

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"

  policy.upgrade_insecure_requests Rails.env.in? %w[uat staging production]
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
