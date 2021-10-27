# frozen_string_literal: true

module Api
  class PartnerSources < Request
    def self.post(env, partner_id, params)
      Api::Request.new(
        "/harvester/partners/#{partner_id}/sources",
        env,
        params
      ).post
    end
  end
end
