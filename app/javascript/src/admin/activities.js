document.addEventListener("turbo:load", function () {
  $("#activities").dataTable({
    order: [[0, "desc"]],
  });
});
