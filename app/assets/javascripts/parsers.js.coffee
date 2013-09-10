# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

stored_sources = null

$ ->
  $("#main").on 'click', 'a.records-preview-button', ->
    $("#preview-area-spinner").show()
    $("#preview-area").html("")
    $("#preview-modal").reveal()

    window.Harvester.myCodeMirror.save()

    $link = $(this)
    $form = $("form")
    $.post $link.attr("href"), $form.serialize(), (data) ->
      $("#preview-area-spinner").hide()
      #$("#preview-area").html(data)

    return false;

  $(".records-harvest-modal-button").click ->
    $link = $(this)
    environment = $link.data("environment")
    $("#harvest_job_environment").val(environment)
    $('#harvest_job_mode_normal').prop('checked','checked')
    $("#harvest-form").show()
    $("#harvest-result").hide()
    $("#harvest-modal").reveal()

    $("#harvest-form form").attr("action", "/" + environment + "/harvest_jobs")

    return false;

  $(".records-enrichment-modal-button").click ->
    $link = $(this)
    environment = $link.data("environment")
    $("#enrichment_job_environment").val(environment)
    $("#enrichment-form").show()
    $("#enrichment-result").hide()
    $("#enrichment-modal").reveal()

    $("#enrichment-form form").attr("action", "/" + environment + "/enrichment_jobs")

    return false;

  $('#rename-parser-action').click ->
    $('#parser-title').hide()
    $('#hidden-parser-form').show()

  $('#cancel-parser-delete').click ->
    $('#delete-parser-alert .close-reveal-modal').trigger('click')
  $('.show_more').click ->
    $('.version.hidden').show();
    $(this).hide();

  stored_sources = $('#parser_source_id optgroup')

  $('#parser_partner').change ->
    partner = $('#parser_partner').val()
    $('#parser_source_id optgroup').remove()
    $('#parser_source_id').append(stored_sources)
    if partner != ""
      $("#parser_source_id optgroup[label!='#{partner}']").remove()

  $('#parsers').dataTable("aaSorting": [ [4,'desc'] ])
  $(document).foundationCustomForms();


