$(function() {
  var $enrichmentJob;
  $enrichmentJob = $("#enrichment-job");
  if ($enrichmentJob.length > 0 && $enrichmentJob.data("active")) {
    return EnrichmentJobsPoller.poll();
  }
});

window.EnrichmentJobsPoller = {
  poll: function() {
    return setTimeout(this.request, 2000);
  },
  request: function() {
    return $.get($("#enrichment-job").data('url'));
  }
};
