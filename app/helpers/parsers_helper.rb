# frozen_string_literal: true

# Helpers for Parsers
module ParsersHelper
  def version_message(parser, version = nil)
    version.nil? ? parser.versions.last.message : version.message
  end

  # Returns the next link for preview view
  #
  # @author Federico Gonzalez
  # @last_modified Eddie
  # @param parser_id [String] the id fo the parser
  # @param index [String] the index of the preview page
  # @param environment [String] the environment set to the parser
  # @param review [String]
  # @param html_options [String] optional options
  #
  # @return [A Tag] of the next preview page
  def link_to_next(parser_id, index, environment, review, html_options = {})
    # index params is nil for the first iteration. to_i will make it 0
    # Its incremented so that in the second iteration previous link can be made visible.
    # Previous link is disabled when index is 0
    path = previews_path(
      parser_id: parser_id,
      index: index.to_i + 1,
      environment: environment,
      review: review,
      format: :js
    )
    link_to 'next >', path, html_options
  end

  # Returns the previous link for preview view
  #
  # @author Federico Gonzalez
  # @last_modified Eddie
  # @param parser_id [String] the id fo the parser
  # @param index [String] the index of the preview page
  # @param environment [String] the environment set to the parser
  # @param review [String]
  # @param html_options [String] optional options
  #
  # @return [A Tag] of the previous preview page
  def link_to_previous(parser_id, index, environment, review, html_options = {})
    index = index.to_i - 1
    path = previews_path(
      parser_id: :parser_id,
      index: index,
      environment: environment,
      review: review,
      format: :js
    )

    if index >= 0
      link_to '< previous', path, html_options
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

  def environment_tag(environment, nested_tag = nil)
    content_tag(:span, safe_join([content_tag(:span, '', class: 'arrow arrow-left'), t("parsers.environments.#{environment}"), nested_tag]), class: "version-tag #{environment}")
  end

  def enrichments(job)
    if job._type.downcase.match?(/enrichment/)
      content_tag(:span, job.try(:enrichment))
    else
      content_tag(:span, '')
    end
  end

  def localize_date_time(date_time)
    date_time.to_datetime.localtime.strftime('%d %b %Y %H:%M')
  end
end
