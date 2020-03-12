$(function() {
  $('#harvest_schedules').dataTable({
    'order': [[6, 'desc']],
    'aoColumnDefs': [
      {
        'bSortable': true,
        'aTargets': [7]
      }
    ]
  });

  $('.datetimepicker').datetimepicker({
    format: 'd/m/Y H:i'
  });

  $('input[name="harvest_schedule[recurrent]"]').change(function() {
    var $checkBox, $recurrentOptions;
    $checkBox = $(this);
    $recurrentOptions = $('#recurrent-options');
    if ($checkBox.is(':checked')) {
      return $recurrentOptions.show();
    } else {
      return $recurrentOptions.hide();
    }
  });

  var $form = $('form[action="/staging/harvest_schedules"]');
  return $($form.find('select[name="harvest_schedule[parser_id]"]')).change(function(event) {
    return $.get($form.attr('action') + '/new.js', $form.serialize());
  });
});
