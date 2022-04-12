document.addEventListener("turbo:load", function () {
  $("#stats").dataTable({
    order: [[0, "desc"]],
  });
});
