# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#records-preview-button").click ->
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

  $("#records-harvest-modal-button").click ->
    $("#harvest-form").show()
    $("#harvest-result").hide()
    $("#harvest-modal").reveal()

    return false;

  $("#records-harvest-button").click ->
    $("#harvest-spinner").show()
    $("#harvest-form").hide()

    $link = $(this)
    $form = $("form")
    $.post $link.attr("href"), $form.serialize(), (data) ->
      $("#harvest-spinner").hide()
      $("#harvest-result").show().html(data)

    return false;