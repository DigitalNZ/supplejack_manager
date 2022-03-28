import CodeMirror from 'codemirror/lib/codemirror'
import 'codemirror/mode/ruby/ruby';
import 'codemirror/mode/xml/xml';

$(function() {
  window.CodeMirror = CodeMirror;
  window.initCodeMirror = function(textarea, readOnly = false) {
    return window.CodeMirror.fromTextArea(textarea, {
      lineNumbers: true,
      theme: 'monokai',
      tabSize: 2,
      readOnly: readOnly,
      lineSeperator: ',',
    });
  }
})
