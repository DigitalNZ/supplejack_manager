$(function() {
  $('#rename-parser-template-action').click(function() {
    $('#parser-template-title').hide();
    return $('#hidden-parser-template-form').show();
  });

  $('#cancel-parser-template-delete').click(function() {
    return $('#delete-parser-template-alert .close-reveal-modal').trigger('click');
  });

  $('#parser-templates').dataTable();
});
