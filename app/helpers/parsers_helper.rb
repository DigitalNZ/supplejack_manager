# The majority of The Supplejack Manager code is Crown copyright (C) 2014,
# New Zealand Government,
# and is licensed under the GNU General Public License, version 3.
# Some components are third party components that are licensed under
# the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and
# the Department of Internal Affairs.
# http://digitalnz.org/supplejack

module ParsersHelper

  def link_to_next(parser_id, index, environment, review, html_options={})
    link_to 'next >', parser_previewers_path(parser_id, index: index.to_i+1, environment: environment, review: review), html_options
  end

  def link_to_previous(parser_id, index, environment, review, html_options={})
    index = index.to_i - 1

    if index >= 0
      link_to '< previous', parser_previewers_path(parser_id, index: index.to_i, environment: environment, review: review), html_options
    else
      html_options[:class] << ' disabled'
      content_tag(:span, '< previous', html_options)
    end
  end

  def environment_tags(version, parser)
    content_tag(:div, class: 'version-tag-container') do
      bubbles = []
      version.tags ||= []
      version.tags.each do |environment|
        label = environment.capitalize.first
        arrow = nil
        classes = ['version-tag', environment]
        if parser.current_version(environment.to_sym) == version
          arrow = content_tag(:span, '', class: 'arrow arrow-left')
          classes << 'current'
        end

        bubbles << content_tag(:span, safe_join([arrow, label]), class: classes.join(' '))
      end
      safe_join(bubbles)
    end
  end

  def environment_tag(environment, nested_tag=nil)
    content_tag(:span, safe_join([content_tag(:span, '', class: 'arrow arrow-left'), t("parsers.environments.#{environment}"), nested_tag]), class: "version-tag #{environment}")
  end

  def enrichments(job)
    if job._type.downcase.match(/enrichment/)
      content_tag(:span, job.try(:enrichment))   
    else
      content_tag(:span, '')   
    end
  end

  def localize_date_time(date_time)
    ActiveSupport::TimeZone['Wellington'].parse(date_time.to_s)
  end
end