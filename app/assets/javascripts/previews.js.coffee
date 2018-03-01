
@PreviewJobsPoller =
  poll: ->
    if @lock == false || @lock == undefined
      @lock = true
      setTimeout @request, 2000 

  request: ->
    PreviewJobsPoller.lock = false
    $.get($("#preview-job").attr('url') + ".js")