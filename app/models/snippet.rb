# frozen_string_literal: true

class Snippet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  include Versioned

  field :content,   type: String

  def self.find_by_name(name, environment)
    snippet = where(name:).first
    snippet.current_version(environment) if snippet.present?
  end

  def file_name
    @file_name ||= self.name.downcase.gsub(/\s/, '_') + '.rb'
  end

  def path
    "snippets/#{file_name}"
  end
end
