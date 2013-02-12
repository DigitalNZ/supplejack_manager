class ParserVersionSerializer < ActiveModel::Serializer
  
  attributes :name, :strategy, :content, :message, :version, :file_name

end