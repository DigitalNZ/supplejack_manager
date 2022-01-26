Rails.application.routes.draw do
  default_url_options DEFAULT_URL_OPTIONS

  root to: 'home#index'

  draw(:action_cable)
  draw(:parsers)
  draw(:partners)
  draw(:lint_parser)
  draw(:snippets)
  draw(:parser_templates)
  draw(:sources)
  draw(:previews)
  draw(:users)

  scope ':environment', as: 'environment' do
    draw(:admin)

    draw(:abstract_jobs)
    draw(:harvest_jobs)
    draw(:enrichment_jobs)
    draw(:harvest_schedules)
    draw(:collection_statistics)
    draw(:link_check_rules)
    draw(:suppress_collections)
    draw(:collection_records)
  end
end
