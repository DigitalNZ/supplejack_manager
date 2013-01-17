$ ->
  window.Harvester.textArea = document.getElementsByClassName("code-editor")[0]

  if window.Harvester.textArea != undefined
    window.Harvester.myCodeMirror = CodeMirror.fromTextArea window.Harvester.textArea, {
      theme: "monokai",
      lineNumbers: true,
      tabSize: 2
    }