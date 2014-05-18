# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

module ActiveResource
  # Active Resource validation is reported to and from this object, which is used by Base#save
  # to determine whether the object in a valid state to be saved. See usage example in Validations.
  class Errors < ActiveModel::Errors
    # Grabs errors from an array of messages (like ActiveRecord::Validations).
    # The second parameter directs the errors cache to be cleared (default)
    # or not (by passing true).
    def from_hash(messages, save_cache = false)
      clear unless save_cache

      messages.each do |(key,errors)|
        errors.each do |error|
          if @base.attributes.keys.include?(key)
            add key, error
          else
            self[:base] << "#{key.humanize} #{error}"
          end
        end
      end
    end

    # Grabs errors from a json response.
    def from_json(json, save_cache = false)
      hash = ActiveSupport::JSON.decode(json)['errors'] || {} rescue {}
      from_hash hash, save_cache
    end
  end
end