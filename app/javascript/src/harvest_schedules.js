document.addEventListener("turbo:load", function () {
  $("#harvest_schedules").dataTable({
    order: [[6, "desc"]],
    aoColumnDefs: [
      {
        bSortable: true,
        aTargets: [7],
      },
    ],
  });

  $(".datetimepicker").datetimepicker({
    format: "d/m/Y H:i",
  });
});
