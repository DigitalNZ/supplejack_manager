# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class Parser
	module TemplateHelpers
		extend ActiveSupport::Concern

		def update_contents_parser_class!
	    if self.changed.include?("name")
	      class_name = self.name.gsub(/\s/, "_").camelize
	      self.content = self.content.gsub(/^class .* </, "class #{class_name} <")
	      self.message = "Renamed parser class"
	    end
	  end

	  def apply_parser_template!
	  	if self.content.nil?

	  		parser_template = []
	  		parser_template << "class #{self.name.gsub(/\s/, "_").camelize} < HarvesterCore::#{self.strategy.capitalize}::Base"
	  		
	  		if parser_template_name.present?
	  			template = ParserTemplate.find_by_name(parser_template_name)
	  			parser_template << "\t" + template.content.gsub(/\n/, "\n\t")
	  		end

	  		parser_template << "end"

	  		self.content = parser_template.join("\n\n")
	  		self.message = "Applied parser template."
	  	end 
	  end
	end
end