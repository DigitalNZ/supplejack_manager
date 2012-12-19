# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  textArea = document.getElementById("parser_data")
  myCodeMirror = CodeMirror.fromTextArea textArea, {
    theme: "monokai",
    lineNumbers: true,
    tabSize: 2
  }

  $("#records-preview-button").click ->
    $("#preview-modal").reveal()

    myCodeMirror.save()

    $link = $(this)
    $form = $link.closest("form")
    $.post $link.attr("href"), $form.serialize(), (data) ->
      $("#preview-area").html(data)

    return false;