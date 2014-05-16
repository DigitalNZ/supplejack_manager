# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

$ ->
	$('#suppress_collection_form select').change ->
		id = $('#suppress_collection_form select').find(":selected").attr("value")
		$('#suppress_collection_form').attr('action', $('#suppress_collection_form').attr('action').replace(/^\/(.*)\/suppress_collections\/.*$/, '/$1/suppress_collections/' + id))