$ ->
  if $("#harvest-job").length > 0
    HarvestJobsPoller.poll()

@HarvestJobsPoller =
  poll: ->
    setTimeout @request, 3000

  request: ->
    $.get($("#harvest-job").data('url'))