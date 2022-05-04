function initDatetimePickers(event) {
  $(event.target).find(".datetimepicker").datetimepicker({
    format: "d/m/Y H:i",
  });
}

document.addEventListener("turbo:load", initDatetimePickers);
document.addEventListener("turbo:frame-load", initDatetimePickers);
