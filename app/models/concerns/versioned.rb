# frozen_string_literal: true

# spec/models/concerns/versioned.rb
module Versioned
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document

    attr_accessor :message, :tags, :user_id

    field :name, type: String

    embeds_many :versions, as: :versionable

    after_save :save_with_version, if: -> { content_previously_changed? }
  end

  def last_edited_by
    versions.last&.user&.name
  end

  def current_version(environment)
    return versions.last if environment.to_sym == :test || environment.to_sym == :preview
    versions.where(tags: environment.to_s).desc(:created_at).first
  end

  def save_with_version
    version_number = versions.count + 1
    versions.create(content: content, tags: tags, message: message, user_id: user_id, version: version_number)
  end

  def find_version(version_id)
    versions.find(version_id)
  end
end
