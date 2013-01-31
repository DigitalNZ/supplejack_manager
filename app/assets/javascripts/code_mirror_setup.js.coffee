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