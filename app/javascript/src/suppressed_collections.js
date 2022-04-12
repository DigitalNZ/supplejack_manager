document.addEventListener("turbo:load", function () {
  return $("#suppress_collection_form select").change(function () {
    var id;
    id = $("#suppress_collection_form select").find(":selected").attr("value");
    return $("#suppress_collection_form").attr(
      "action",
      $("#suppress_collection_form")
        .attr("action")
        .replace(
          /^\/(.*)\/suppress_collections\/.*$/,
          "/$1/suppress_collections/" + id
        )
    );
  });
});
