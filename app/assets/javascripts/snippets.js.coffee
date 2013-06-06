$ ->
	$('#rename-snippet-action').click ->
	  $('#snippet-title').hide()
	  $('#hidden-snippet-form').show()

	$('#cancel-snippet-delete').click ->
    $('#delete-snippet-alert .close-reveal-modal').trigger('click')