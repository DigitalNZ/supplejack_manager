# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

module CollectionStatisticsHelper
	def link_to_previous_day(day, environment, html_options={})
		if (@day.to_date - 1.day) < 1.month.ago.to_date
			html_options[:class] << " disabled"
      content_tag(:span, "", html_options)
		else
			link_to "", environment_collection_statistic_path(params[:environment], (@day.to_date - 1.day).to_s), html_options
		end
	end
	def link_to_next_day(day, environment, html_options={})
		if (@day.to_date + 1.day) > Date.today
			html_options[:class] << " disabled"
      content_tag(:span, "", html_options)
		else
			link_to "", environment_collection_statistic_path(params[:environment], (@day.to_date + 1.day).to_s), html_options
		end
	end
end