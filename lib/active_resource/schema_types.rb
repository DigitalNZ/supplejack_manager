# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

module ActiveResource
  module SchemaTypes
    extend ActiveSupport::Concern

    module DateTime
      def self.cast_value(value)
        if value.is_a?(::String)
          value = value.present? ? ::Time.parse(value) : nil
        end
        value
      end
    end

    module Date
      def self.cast_value(value)
        if value.is_a?(::String)
          value = value.present? ? ::Date.parse(value) : nil
        end
        value
      end
    end

    module String
      def self.cast_value(value)
        value
      end
    end

    module Boolean
      def self.cast_value(value)
        return true if value.to_s.match(/true|1/) || value == true
        return false if value.to_s.match(/false|0/) || value == false
        return nil
      end
    end

    TYPE_MAPPINGS = {
                      "datetime" => ActiveResource::SchemaTypes::DateTime, 
                      "date" =>     ActiveResource::SchemaTypes::Date,
                      "boolean" =>  ActiveResource::SchemaTypes::Boolean
                    }

    included do
      schema.each do |attribute, type|
        define_method(attribute) do
          type = self.class.schema[attribute.to_s]
          type = TYPE_MAPPINGS[type] || ActiveResource::SchemaTypes::String
          type = ActiveResource::SchemaTypes::String unless defined?(type)
          type.cast_value(@attributes[attribute])
        end
      end
    end

    
  end
end