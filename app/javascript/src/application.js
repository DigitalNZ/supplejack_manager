// yarn packages
require('jquery')
require('jquery-ui')
require('jquery-datetimepicker')
require('foundation-sites')
require('moment')
require('codemirror/mode/ruby/ruby')
require('codemirror/mode/xml/xml')
// those 2 are not working with require
import 'datatables.net';
import 'datatables.net-zf';

// local files, please keep this alphabetically ordered
require('./admin/users')
require('./admin/activities')
require('./code_mirror_setup')
require('./collection_statistics')
require('./datatables.foundation')
require('./enrichment_jobs')
require('./harvest_errors')
require('./harvest_jobs')
require('./harvest_schedules')
require('./harvester')
require('./link_check_rules')
require('./parser_templates')
require('./parsers')
require('./partners')
require('./snippets')
require('./sources')
require('./suppressed_collections')


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
  $(document).foundation();
});
