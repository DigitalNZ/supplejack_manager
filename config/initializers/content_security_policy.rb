# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src     :none
  policy.font_src        :self
  policy.img_src         :self, :data, 'https://ajax.googleapis.com'
  policy.object_src      :none
  policy.base_uri        :none
  policy.script_src      :self, :unsafe_inline
  policy.frame_ancestors :none
  policy.form_action     :self

  policy.style_src       :self, 'https://ajax.googleapis.com'
  if Rails.env.in? %w[test development]
    # we have to add unsafe_inline in development because the css loader
    # injects inline styles
    policy.style_src     :self, 'https://ajax.googleapis.com', :unsafe_inline
  end

  policy.connect_src     :self
  # If you are using webpack-dev-server then specify webpack-dev-server host
  if Rails.env.in? %w[test development]
    policy.connect_src :self, :https, "http://localhost:3036", "ws://localhost:3036"
  end

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
