$ ->  
  $harvestJob = $("#harvest-job")
  if $harvestJob.length > 0 && $harvestJob.data("active")
    HarvestJobsPoller.poll()
  $('[name="harvest_job[mode]"]').change ->
    box = $('#harvest_job_limit')
    if $('#harvest_job_mode_full_and_flush')[0].checked
      box.attr('value', '')
      box.attr('disabled','disabled')
    else
      box.removeAttr('disabled')

@HarvestJobsPoller =
  poll: ->
    setTimeout @request, 2000

  request: ->
    $.get($("#harvest-job").data('url') + ".js")

