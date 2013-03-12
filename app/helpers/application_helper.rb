module ApplicationHelper
  include WorkerEnvironmentHelpers
  
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def link_to_tab(name, path, html_options={})
    li_options = {}
    li_options.reverse_merge!({class: "active"}) if request.path == path
    content_tag(:li, link_to(name, path, html_options), li_options)
  end
end