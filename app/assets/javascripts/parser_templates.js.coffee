$ ->
	$('#rename-parser-template-action').click ->
	  $('#parser-template-title').hide()
	  $('#hidden-parser-template-form').show()

	$('#cancel-parser-template-delete').click ->
    $('#delete-parser-template-alert .close-reveal-modal').trigger('click')