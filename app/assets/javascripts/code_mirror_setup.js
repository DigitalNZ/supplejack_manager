$(function() {
  Harvester.textArea = document.getElementsByClassName("code-editor")[0];
  Harvester.readOnly = function() {
    return $(Harvester.textArea).hasClass("read-only");
  };
  if (Harvester.textArea !== void 0) {
    Harvester.myCodeMirror = CodeMirror.fromTextArea(Harvester.textArea, {
      theme: "monokai",
      lineNumbers: true,
      tabSize: 2,
      readOnly: Harvester.readOnly()
    });
    $(window).data("beforeunload", function() {
      return "You've modified your parser, reloading the page will reset all changes.";
    });
    Harvester.myCodeMirror.on("change", function() {
      $(window).data("codechange", true);
      return window.onbeforeunload = $(window).data("beforeunload");
    });
    return $(".edit_parser input[value='Update Parser Script'], .edit_snippet input[value='Update Snippet'], .new_snippet input[value='Create Snippet'], .new_parser_template input[value='Create Parser template'], .edit_parser_template input[value='Update Parser template']").hover((function() {
      return window.onbeforeunload = null;
    }), function() {
      if ($(window).data("codechange")) {
        return window.onbeforeunload = $(window).data("beforeunload");
      }
    });
  }
});
