module Versioned
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document

    attr_accessor :message, :tags, :user_id

    field :name, type: String

    embeds_many :versions, as: :versionable

    after_save :save_with_version, if: -> {self.content_changed?}
  end

  def last_edited_by
    self.versions.last.try(:user).try(:name)
  end

  def current_version(environment)
    return self.versions.last if environment.to_sym == :test or environment.to_sym == :preview
    self.versions.where(tags: environment.to_s).desc(:created_at).first
  end

  def save_with_version
    version_number = self.versions.count + 1
    self.versions.create(content: content, tags: tags, message: message, user_id: user_id, version: version_number)
  end

  def find_version(version_id)
    self.versions.find(version_id)
  end

end
