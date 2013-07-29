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