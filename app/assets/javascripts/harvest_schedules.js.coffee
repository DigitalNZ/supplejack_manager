# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

$ ->
  $('#harvest_schedules').dataTable({
    "order": [ [6,'desc'] ],
    "aoColumnDefs": [{
      "bSortable": false,
      "aTargets": [7]
    }]
  })

  # TODO
  # $('.datetimepicker').datetimepicker({ dateFormat: "dd/mm/yy", minDate: 0, timeFormat: "HH:mm z"});

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
