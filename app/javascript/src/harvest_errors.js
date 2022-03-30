document.addEventListener('turbo:load', function() {
  var code_mirror_text_areas = document.getElementsByClassName('code-editor-multiple');

  $(code_mirror_text_areas).each(function(key, value) {
    CodeMirror.fromTextArea(value, {
      lineNumbers: true,
      theme: 'monokai',
      tabSize: 2,
      readOnly: true,
      mode: $(value).data('mode'),
      lineSeperator: ','
    })
  });

  $("#accordion-failed, #accordion-invalid, #accordion-backtrace").accordion({heightStyle: "content",collapsible: true, active: false});
});
