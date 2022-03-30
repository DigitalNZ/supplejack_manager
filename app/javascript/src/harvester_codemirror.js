document.addEventListener('turbo:load', function() {
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
    Harvester.myCodeMirror.on('change', function() {
      $(window).data("codechange", true);
      return window.onbeforeunload = $(window).data("beforeunload");
    });
    return $("form[method='post'] input[value='Update Parser Script'], form[method='post'] input[value='Update Snippet'], form[method='post'] input[value='Create Snippet'], form[action='/parser_templates'] input[value='Create Parser template'], form[method='post'] input[value='Update Parser template']").hover((function() {
      return window.onbeforeunload = null;
    }), function() {
      if ($(window).data("codechange")) {
        return window.onbeforeunload = $(window).data("beforeunload");
      }
    });
  }
});
