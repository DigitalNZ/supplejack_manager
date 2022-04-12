// yarn packages and files to import jquery
// and globally accessible libraries
import "./src/jquery";
import "jquery-ui-dist/jquery-ui.min.js";
import "jquery-datetimepicker";
import "foundation-sites";
import "moment";
import "./src/codemirror";
import "./src/datatable.js";
import "@hotwired/turbo-rails";
import "./controllers";
import RailsUJS from "@rails/ujs";
RailsUJS.start();

// local files, please keep this alphabetically ordered
import "./src/admin/users";
import "./src/admin/activities";
import "./src/apm";
import "./channels";
import "./src/collection_statistics";
import "./src/datatables.foundation";
import "./src/enrichment_jobs";
import "./src/harvest_errors";
import "./src/harvest_schedules";
import "./src/harvester";
import "./src/harvester_codemirror";
import "./src/link_check_rules";
import "./src/parser_templates";
import "./src/parsers";
import "./src/partners";
import "./src/reset_modal_on_close";
import "./src/snippets";
import "./src/sources";
import "./src/suppressed_collections";

function initJS() {
  $(document).foundation();
  $("#turbo-transition").hide();
}

document.addEventListener("turbo:load", initJS);
document.addEventListener("turbo:frame-load", initJS);

document.addEventListener("turbo:click", function () {
  $("#turbo-transition").show();
});
