document.addEventListener("turbo:load", function () {
  $("form.collection_records select").on("change", function () {
    this.form.submit();
  });
});
