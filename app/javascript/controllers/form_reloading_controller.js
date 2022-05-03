import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  connect() {
    let $input = $(this.element);
    let $form = $input.parents("form");
    $input.on("change", () => {
      $form.parent("turbo-frame")[0].src = `${
        window.location.pathname
      }?${$form.serialize()}`;
    });
  }
}
