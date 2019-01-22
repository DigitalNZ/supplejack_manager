$(function() {
  var parser_id = $('#parser_id').val();
  var user_id = $('#user_id').val();

  App.preview = App.cable.subscriptions.create({ channel: "PreviewChannel", parser_id: parser_id, user_id: user_id }, {
    connected: function() {
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {

      console.log(data);

      $('#status').html(data.status);

      $('#record-raw-data').html(data.raw_data);
      $('#harvest-attributes').html(data.harvested_attributes);
      $('#api-record').html(data.api_record);

      if(data.field_errors) {
        $('#status').html("Field Errors");
        $('#field-errors p').html(data.field_errors);
        $('#field-errors').show();
      }

      if(data.deletable == true) {
        $('#record-to-delete').show();
      }

      if(data.validation_errors) {
        $('#status').html("Validation Errors");

        $.each(JSON.parse(data.validation_errors), function(key, value) {
          $.each(value, function(attribute, message) {
            $('#validation-errors ul').append("<li><strong>" + attribute + ": </strong> " + message + "</li>");
          });
        })

        $('#validation-errors').show();
      }

      if(data.harvest_job_errors) {
        $('#status').html('Harvest Failed');
        $('#harvest-errors').html('');

        $.each(JSON.parse(data.harvest_job_errors), function(message) {
          $('#harvest-errors').append("<p><strong>" + message + "<strong></p>");
        });

        $('#harvest-errors').show();
      }

      if(data.harvest_failure) {
        var failure = JSON.parse(data.harvest_failure);

        $('#status').html("Harvest Failed");
        $('#harvest-failure h6').html(failure.exception_class);
        $('#harvest-failure p').html(failure.message);

        $.each(failure.backtrace, function(key, value) {
          $('#harvest-failure ul').append("<li>" + value + "</li>");
        });
      }

      // Status Log

      if(data.status) {
        $('#status-log').append("<p>" + data.status + "</p>");
      }

      if(data.status_log) {
        $('#status-log').append("<p>" + data.status_log + "</p>");
      }
    }
  });
});
