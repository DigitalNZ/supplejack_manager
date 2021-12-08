
//
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

var stored_sources;

stored_sources = null;

$(function() {

  $("form[action^='/parsers/'] input[name='parser[message]'").submit(function(e) {
    var parser_message;
    parser_message = $('input[name="parser[message]"').val();
    if (!parser_message) {
      alert('Message is required');
      return e.preventDefault();
    }
  });

  $('body').on('click', 'a.records-preview-button', function(e) {
    e.preventDefault();

    var $form, $link;

    $("#preview-area-spinner").show();
    $("#preview-area").html("");
    $("#preview-modal").foundation('open');
    window.Harvester.myCodeMirror.save();

    $link = $(this);
    $form = $("#parser_content");

    $.post($link.attr("href"), $form.serialize(), function(data) {
      return $("#preview-area-spinner").hide();
    });

    return false;
  });

  $(".records-harvest-modal-button").click(function(e) {
    e.preventDefault();

    var $link, environment;
    $link = $(this);
    environment = $link.data("environment");
    $("#harvest_job_environment").val(environment);
    $('#harvest_job_mode_normal').prop('checked', 'checked');
    $("#harvest-form").show();
    $("#harvest-result").hide();
    $("#harvest-modal").foundation('open');
    $("#harvest-form form").attr("action", "/" + environment + "/harvest_jobs");
    $.get($(this).attr("href"), {
      'environment': environment
    });
    return false;
  });

  $(".records-enrichment-modal-button").click(function() {
    var $link, environment;
    $link = $(this);
    environment = $link.data("environment");
    $("#enrichment-form").show();
    $("#enrichment-result").hide();
    $("#enrichment-modal").foundation('open');
    $("#enrichment-form form").attr("action", "/" + environment + "/enrichment_jobs");
    $.get($(this).attr("href"), {
      'environment': environment
    });
    return false;
  });

  $('#cancel-parser-delete').click(function() {
    return $('#delete-parser-alert .close-reveal-modal').trigger('click');
  });

  $('.show_more').click(function() {
    $('.version.hidden').show();
    return $(this).hide();
  });


  var update_source_from_contributor_value = function($stored_sources) {
    var partner = $('select[name="parser[partner]"]').val();
    $('select[name="parser[source_id]"] optgroup').remove();
    $('select[name="parser[source_id]"]').append($stored_sources);

    // set the active item.
    var currentSourceId = $("label[for='parser_source']").data('currentSourceId');
    $('#parser_source_id').val(currentSourceId);

    if (partner !== "") {
      return $("select[name=\"parser[source_id]\"] optgroup[label!='" + partner + "']").remove();
    }
  }

  var $stored_sources = $('select[name="parser[source_id]"] optgroup');
  update_source_from_contributor_value($stored_sources)
  $('select[name="parser[partner]"]').change(function() {
    update_source_from_contributor_value($stored_sources)
  });

  var table = $('#parsers').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": {
      "url": "/parsers/datatable",
      "data": function(data) {
        data.search.type = $('input[name="type"]:checked').val();
      }
    },
    "aaSorting": [[4, 'desc']],
    "columns": [
      {
        "data": "name",
        "render": function(data, type, row, meta) {
          return '<a href="/parsers/' + row.id + '/edit">' + data + '</a>';
        }
      },
      { "data": "strategy" },
      {
        "data": "partner_name",
        "render": function(data, type, row, meta) {
          if (!row.can_update) return row.partner_name;
          return '<a href="/partners/' + row.partner.id + '/edit">' + row.partner.name + '</a>';
        }
      },
      {
        "data": "source_name",
        "render": function(data, type, row, meta) {
          if (!row.can_update) return row.source.name;
          return '<a href="/sources/' + row.source.id + '/edit">' + row.source.name + '</a>';
        }
      },
      { "data": "updated_at" },
      { "data": "last_editor" },
      { "data": "data_type" },
    ]
  });

  $('input[value="quick_search"]').on('click', function() {
    table.fnDraw();
  });

  $('input[value="content_search"]').on('click', function() {
    table.fnDraw();
  });
});

// $(document).foundationCustomForms();
