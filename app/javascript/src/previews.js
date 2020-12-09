window.PreviewJobsPoller = {
  poll: function() {
    if (this.lock === false || this.lock === void 0) {
      this.lock = true;
      return setTimeout(this.request, 2000);
    }
  },
  request: function() {
    PreviewJobsPoller.lock = false;
    return $.get($("#preview-job").attr('url') + ".js");
  }
}
