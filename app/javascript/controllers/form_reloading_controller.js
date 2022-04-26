import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  connect() {
    console.log("connect input");
    let $input = $(this.element);
    let $form = $input.parents("form");
    $input.on("change", () => {
      $form.parent("turbo-frame")[0].src = `${
        window.location.pathname
      }?${$form.serialize()}`;
    });
  }

  disconnect() {}
}

// $('input[name="harvest_schedule[recurrent]"]').on("change", function () {
//   var $checkBox, $recurrentOptions;
//   $checkBox = $(this);
//   $recurrentOptions = $("#recurrent-options");
//   if ($checkBox.is(":checked")) {
//     return $recurrentOptions.show();
//   } else {
//     return $recurrentOptions.hide();
//   }
// });

// var $form = $("#harvest-schedule-form form");
// $form
//   .find('select[name="harvest_schedule[parser_id]"]')
//   .on("change", function (event) {
//     return $.get($form.attr("action") + "/new.js", );
//   });
