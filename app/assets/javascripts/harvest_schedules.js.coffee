$ ->
  $('.datetimepicker').datetimepicker({ dateFormat: "dd/mm/yy", minDate: 0, timeFormat: "HH:mm z"});

  $("#harvest_schedule_recurrent").click ->
    $checkBox = $(this)
    $recurrentOptions = $("#recurrent-options")

    if $checkBox.is(":checked")
      $recurrentOptions.show()
    else
      $recurrentOptions.hide()
