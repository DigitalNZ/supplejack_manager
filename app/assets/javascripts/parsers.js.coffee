# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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
      $("#preview-area").html(data)

    return false;

  $(".records-harvest-modal-button").click ->
    $link = $(this)
    environment = $link.data("environment")
    $("#harvest_job_environment").val(environment)
    $("#harvest-form").show()
    $("#harvest-result").hide()
    $("#harvest-modal").reveal()

    $("#harvest-form form").attr("action", "/" + environment + "/harvest_jobs")

    return false;

  $("#preview-area").on 'click', '#record-raw-data-button', ->
    $("#record-raw-data").show()
    $("#record-attributes").hide()
    return false;

  $("#preview-area").on 'click', '#record-attributes-button', ->
    $("#record-raw-data").hide()
    $("#record-attributes").show()
    return false;