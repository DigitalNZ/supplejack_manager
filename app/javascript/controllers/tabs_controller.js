import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    new Foundation.Tabs($(this.element));
    $(this.element).on("change.zf.tabs", function (event) {
      const tabsTarget = $("#preview-tabs")
        .find("li.is-active a")
        .data("tabsTarget");
      const tabElement = $(`#${tabsTarget}`);

      tabElement.find(".CodeMirror").each(function (_, codemirror) {
        codemirror.parentNode.removeChild(codemirror);
      });
      tabElement.find(".code-editor-multiple").each(function (_, textarea) {
        initCodeMirror(textarea);
      });
    });
  }
}
