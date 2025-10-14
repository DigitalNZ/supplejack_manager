document.addEventListener("turbo:load", function () {
  $("#cancel-parser-template-delete").on("click", function () {
    return $("#delete-parser-template-alert .close-reveal-modal").trigger(
      "click",
    );
  });

  $("#parser-templates").dataTable({
    order: [[2, "desc"]],
  });
});
