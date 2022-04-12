document.addEventListener("turbo:load", function () {
  $("[reset-modal-on-close]").each(function (_, modal) {
    modal = $(modal);

    let modalContent = modal.html();
    modal.on("closed.zf.reveal", function () {
      modal.html(modalContent);
    });
  });
});
