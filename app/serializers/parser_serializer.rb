class ParserSerializer < ActiveModel::Serializer
  
  attributes :name, :strategy, :content, :file_name

end