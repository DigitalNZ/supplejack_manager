$ ->
	$('#suppress_collection_form select').change ->
		id = $('#suppress_collection_form select').find(":selected").attr("value")
		$('#suppress_collection_form').attr('action', '/staging/suppress_collections/' + id )