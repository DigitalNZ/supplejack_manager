import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("click", this.loadPreview);
  }

  loadPreview(e) {
    e.preventDefault();

    $("#preview-area-spinner").show();
    $("#preview-area").html("");
    window.Harvester.myCodeMirror.save();

    let form = $("#parser_content")
      .parent("form")
      .serialize()
      .replace("_method=patch", "_method=post");

    $.post(this.href, form, function (preview) {
      $("#preview-area").html(`
        <turbo-frame id="preview_${preview.id}" src="/previews/${preview.id}.turbo_stream">
        </turbo-frame>
      `);

      $("#preview-area-spinner").hide();
    });

    return false;
  }
}
