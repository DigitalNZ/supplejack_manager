$ ->
  if $("#harvest-job").length > 0
    HarvestJobsPoller.poll()

@HarvestJobsPoller =
  poll: ->
    setTimeout @request, 2000

  request: ->
    $.get($("#harvest-job").data('url'))