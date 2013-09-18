class SnippetVersionSerializer < ActiveModel::Serializer

  attributes :id, :snippet_id, :name, :content, :message, :version, :file_name

  def snippet_id
    self.object.versionable.try(:id)
  end
end
