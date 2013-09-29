$ ->
	$('#suppress_collection_form select').change ->
		id = $('#suppress_collection_form select').find(":selected").attr("value")
		$('#suppress_collection_form').attr('action', $('#suppress_collection_form').attr('action').replace(/^\/(.*)\/suppress_collections\/.*$/, '/$1/suppress_collection/' + id))