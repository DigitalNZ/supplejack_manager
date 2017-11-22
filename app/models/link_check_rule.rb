# frozen_string_literal: true

# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# app/models/link_check_rule.rb
class LinkCheckRule < ActiveResource::Base
  include EnvironmentHelpers

  self.site = ENV['WORKER_HOST']
  self.user = ENV['WORKER_API_KEY']

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
