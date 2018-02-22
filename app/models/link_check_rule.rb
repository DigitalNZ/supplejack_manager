# frozen_string_literal: true

# app/models/link_check_rule.rb
class LinkCheckRule < ActiveResource::Base
  include EnvironmentHelpers

  self.site = ENV['WORKER_HOST']
  headers['Authorization'] = "Token token=#{ENV['WORKER_KEY']}"

  schema do
    attribute :source_id,        :string
    attribute :xpath,            :string
    attribute :status_codes,     :string
    attribute :active,           :boolean
    attribute :throttle,         :integer
    attribute :_id,              :string
  end

  include ActiveResource::SchemaTypes

  def id
    _id
  end

  def source
    Source.find(self.source_id) rescue nil
  end
end
