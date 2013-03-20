$ ->
  
  $enrichmentJob = $("#enrichment-job")
  if $enrichmentJob.length > 0 && $enrichmentJob.data("active")
    EnrichmentJobsPoller.poll()

@EnrichmentJobsPoller =
  poll: ->
    setTimeout @request, 2000

  request: ->
    $.get($("#enrichment-job").data('url'))