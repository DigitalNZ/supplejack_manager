$ ->
  $('.datetimepicker').datetimepicker({ dateFormat: "dd/mm/yy", minDate: 0, timeFormat: "HH:mm z"});

  $("#harvest_schedule_recurrent").click ->
    $checkBox = $(this)
    $recurrentOptions = $("#recurrent-options")

    if $checkBox.is(":checked")
      $recurrentOptions.show()
    else
      $recurrentOptions.hide()

  $("#harvest-schedule-form").on("change", "#harvest_schedule_parser_id", (event) ->
    $form = $("form.harvest_schedule")
    new_path = $form.attr("action") + "/new.js"

    $.get(new_path, $form.serialize())
  )