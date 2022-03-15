import moment from 'moment';

var fold_create_fields = function(select, fields) {
  if ($(select).val() === "") {
    $(fields).show();
    $(fields + ' input').attr('disabled', false);
    return $(fields + ' select').attr('disabled', false);
  } else {
    $(fields).hide();
    $(fields + ' input').attr('disabled', true);
    return $(fields + ' select').attr('disabled', true);
  }
};

document.addEventListener('turbo:load', function() {
  var update_link, update_time;

  $('#sources').dataTable();

  fold_create_fields('select[name="source[partner_id]"]', '#new-partner-fields');
  $('select[name="source[partner_id]"]').change(function() {
    return fold_create_fields('select[name="source[partner_id]"]', '#new-partner-fields');
  });

  update_link = function() {
    var env, link, new_date, now, time_ago, time_ago_ms;
    time_ago = $("#date-slider").slider("value");
    env = $('#environment').val();
    link = $('#reindex-button').attr('data-url');
    if (time_ago !== 0) {
      time_ago_ms = time_ago * 5 * 60 * 1000;
      now = new Date();
      new_date = new Date(now - time_ago_ms);
      return $('#reindex-button').attr('href', link + "?env=" + env + "&date=" + new_date.toISOString());
    } else {
      return $('#reindex-button').attr('href', link + "?env=" + env);
    }
  };

  update_time = function() {
    var new_date, now, time_ago, time_ago_ms;
    time_ago = $("#date-slider").slider("value");
    if (time_ago === 0) {
      $('#time').html('All records');
    } else {
      time_ago_ms = time_ago * 5 * 60 * 1000;
      now = new Date();
      new_date = new Date(now - time_ago_ms);
      $('#time').html(moment().diff(moment(new_date), 'minutes') + " minutes ago (" + moment(new_date).format("hh:mm A") + ")");
    }
    return update_link();
  };

  $("#date-slider").slider({
    orientation: "horizontal",
    range: "min",
    max: 49,
    value: 0,
    slide: update_time,
    change: update_time
  });

  $('#environment').change(function() {
    return update_link();
  });

  if ($("#date-slider").length !== 0) {
    return update_link();
  }
});
