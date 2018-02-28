
$ ->
  $('#harvest_schedules').dataTable({
    "order": [ [6,'desc'] ],
    "aoColumnDefs": [{
      "bSortable": true,
      "aTargets": [7]
    }]
  })

  $('.datetimepicker').datepicker({ dateFormat: "dd/mm/yy", minDate: 0});

  $("#harvest_schedule_recurrent").click ->
    $checkBox = $(this)
    $recurrentOptions = $("#recurrent-options")

    if $checkBox.is(":checked")
      $recurrentOptions.show()
    else
      $recurrentOptions.hide()

  $("#new_harvest_schedule").on("change", "#harvest_schedule_parser_id", (event) ->
    $form = $("form.harvest_schedule")
    new_path = $form.attr("action") + "/new.js"

    $.get(new_path, $form.serialize())
  )
