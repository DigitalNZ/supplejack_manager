$ ->  
  $harvestJob = $("#harvest-job")
  if $harvestJob.length > 0 && $harvestJob.data("active")
    HarvestJobsPoller.poll()

@HarvestJobsPoller =
  poll: ->
    setTimeout @request, 2000

  request: ->
    $.get($("#harvest-job").data('url') + ".js")