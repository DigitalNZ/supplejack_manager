class ParserSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :strategy, :content, :file_name

end