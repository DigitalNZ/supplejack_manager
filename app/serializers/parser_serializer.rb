
class ParserSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :strategy, :content, :file_name, :source, :data_type, :allow_full_and_flush

end