# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#records-preview-button").click ->
    $("#preview-area-spinner").show();
    $("#preview-area").html("")
    $("#preview-modal").reveal()

    myCodeMirror.save()

    $link = $(this)
    $form = $link.closest("form")
    $.post $link.attr("href"), $form.serialize(), (data) ->
      $("#preview-area-spinner").hide();
      $("#preview-area").html(data)

    return false;