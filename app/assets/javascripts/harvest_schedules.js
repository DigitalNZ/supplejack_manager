$(function() {
  $('#harvest_schedules').dataTable({
    "order": [[6, 'desc']],
    "aoColumnDefs": [
      {
        "bSortable": true,
        "aTargets": [7]
      }
    ]
  });
  $('.datetimepicker').datepicker({
    dateFormat: "dd/mm/yy",
    minDate: 0
  });
  $("#harvest_schedule_recurrent").click(function() {
    var $checkBox, $recurrentOptions;
    $checkBox = $(this);
    $recurrentOptions = $("#recurrent-options");
    if ($checkBox.is(":checked")) {
      return $recurrentOptions.show();
    } else {
      return $recurrentOptions.hide();
    }
  });
  return $("#new_harvest_schedule").on("change", "#harvest_schedule_parser_id", function(event) {
    var $form, new_path;
    $form = $("form.harvest_schedule");
    new_path = $form.attr("action") + "/new.js";
    return $.get(new_path, $form.serialize());
  });
});
