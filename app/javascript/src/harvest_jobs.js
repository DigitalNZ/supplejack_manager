$(function() {
  var $harvestJob;
  $harvestJob = $("#harvest-job");
  if ($harvestJob.length > 0 && $harvestJob.data("active")) {
    HarvestJobsPoller.poll();
  }
  return $('[name="harvest_job[mode]"]').change(function() {
    var box;
    box = $('#harvest_job_limit');
    if ($('#harvest_job_mode_full_and_flush')[0].checked) {
      box.attr('value', '');
      return box.attr('disabled', 'disabled');
    } else {
      return box.removeAttr('disabled');
    }
  });
});

window.HarvestJobsPoller = {
  poll: function() {
    return setTimeout(this.request, 2000);
  },
  request: function() {
    return $.get($("#harvest-job").data('url'));
  }
};
