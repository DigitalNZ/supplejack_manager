$ ->
  textArea = document.getElementsByClassName("code-editor")[0]

  if textArea != undefined
    myCodeMirror = CodeMirror.fromTextArea textArea, {
      theme: "monokai",
      lineNumbers: true,
      tabSize: 2
    }