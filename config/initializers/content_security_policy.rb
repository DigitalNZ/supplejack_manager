# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src     :none

    # alphabetically ordered
    policy.base_uri        :none
    policy.connect_src     :self
    policy.img_src         :self, :data, 'https://ajax.googleapis.com'
    policy.font_src        :self
    policy.form_action     :self
    policy.frame_ancestors :none
    policy.object_src      :none
    policy.script_src      :self
    policy.style_src       :self, 'https://ajax.googleapis.com'

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"

    policy.upgrade_insecure_requests Rails.env.in? %w[uat staging production]
  end
end
