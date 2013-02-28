class ParserVersionSerializer < ActiveModel::Serializer
  
  attributes :id, :parser_id, :name, :strategy, :content, :message, :version, :file_name

  def parser_id
    self.object.parser.try(:id)
  end
end