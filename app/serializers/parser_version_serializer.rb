# frozen_string_literal: true

class ParserVersionSerializer < ActiveModel::Serializer
  attributes :id, :parser_id, :name, :strategy, :content, :message,
             :version, :file_name, :data_type

  def parser_id
    object.versionable.try(:id)
  end

  def data_type
    object.versionable.try(:data_type)
  end
end
