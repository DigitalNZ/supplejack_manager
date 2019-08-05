
//
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

var stored_sources;

stored_sources = null;

$(function() {

  $(".edit_parser input[value='Update Parser Script']").click(function(e) {
    var parser_message;
    parser_message = $('input#parser_message').val();
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

  $('#rename-parser-action').click(function() {
    $('#parser-title').hide();
    return $('#hidden-parser-form').show();
  });

  $('#cancel-parser-delete').click(function() {
    return $('#delete-parser-alert .close-reveal-modal').trigger('click');
  });

  $('.show_more').click(function() {
    $('.version.hidden').show();
    return $(this).hide();
  });

  stored_sources = $('#parser_source_id optgroup');
  $('#parser_partner').change(function() {
    var partner;
    partner = $('#parser_partner').val();
    $('#parser_source_id optgroup').remove();
    $('#parser_source_id').append(stored_sources);
    if (partner !== "") {
      return $("#parser_source_id optgroup[label!='" + partner + "']").remove();
    }
  });



  return $('#parsers').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": "/parsers/datatable",
    "aaSorting": [[4, 'desc']],
    "columns": [
      {
        "data": "name",
        "render": function(data, type, row, meta) {
          return `<a href="/parsers/${row.id}/edit">${data}</a>`;
        }
      },
      { "data": "strategy" },
      {
        "data": "partner_name",
        "render": function(data, type, row, meta) {
          debugger;
          if (!row.can_update) return row.partner_name;
          return `<a href="/partners/${row.partner.id}/edit">${row.partner.name}</a>`;
        }
      },
      {
        "data": "source_name",
        "render": function(data, type, row, meta) {
          if (!row.can_update) return row.source.name;
          return `<a href="/sources/${row.source.id}/edit">${row.source.name}</a>`;
        }
      },
      { "data": "updated_at" },
      { "data": "last_editor" },
      { "data": "data_type" },
    ]
  });
});

// $(document).foundationCustomForms();
