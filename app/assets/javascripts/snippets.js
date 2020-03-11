$(function() {
  $('#cancel-snippet-delete').click(function() {
    return $('#delete-snippet-alert .close-reveal-modal').trigger('click');
  });

  $('#snippets').dataTable({
    order: [[2, 'desc']]
  });
});
