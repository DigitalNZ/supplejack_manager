$ ->
  Harvester.textArea = document.getElementsByClassName("code-editor")[0]

  Harvester.readOnly = ->
    $(Harvester.textArea).hasClass("read-only")


  if Harvester.textArea != undefined
    Harvester.myCodeMirror = CodeMirror.fromTextArea Harvester.textArea, {
      theme: "monokai",
      lineNumbers: true,
      tabSize: 2,
      readOnly: Harvester.readOnly()
    }

    $(window).data "beforeunload", ->
      "You've modified your parser, reloading the page will reset all changes."

    Harvester.myCodeMirror.on "change", ->
      $(window).data "codechange", true
      window.onbeforeunload = $(window).data "beforeunload"

    $(".edit_parser input[value='Update Parser'], .edit_snippet input[value='Update Snippet'], .new_snippet input[value='Create Snippet'], .new_parser_template input[value='Create Parser template'], .edit_parser_template input[value='Update Parser template']").hover (->
      window.onbeforeunload = null
    ), ->
      window.onbeforeunload = $(window).data "beforeunload" if $(window).data("codechange")
