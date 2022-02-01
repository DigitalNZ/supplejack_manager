# frozen_string_literal: true

return if Rails.env.test? || Rails.env.development?

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.ignore_actions = ['StatusController#index']
  config.lograge.formatter = Class.new do |fmt|
    def fmt.call(data)
      { msg: 'Request', request: data }
    end
  end

  config.lograge.custom_options = lambda do |event|
    {
      request_id: event.payload[:request_id],
      params: (event.payload[:params] || {}).except('controller', 'action', 'format', 'id').to_s,
      user_id: event.payload[:user_id],
      time: event.time.to_f
    }
  end

  config.lograge.custom_payload do |controller|
    {
      user_id: controller.current_user&.id,
      request_id: controller.request.request_id
    }
  end
end
