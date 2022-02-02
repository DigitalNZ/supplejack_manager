import consumer from './consumer'

const PreviewChannel = (id) => {
  let currentPreview = {};

  const updateResult = (tabSelector, value) => {
    $(`${tabSelector} .CodeMirror`).remove();
    const textarea = document.querySelector(`${tabSelector} > textarea`);
    textarea.value = value;
    window.initCodeMirror(textarea, true);
  }

  const initCodeMirrorOnTabsClick = (labelSelector, attribute) => {
    $(labelSelector).on('click', function(event) {
      // the timeout is required for CodeMirror to work on a tab change ¯\_(ツ)_/¯
      setTimeout(function() {
        let object = null;
        try {
          object = JSON.stringify(
            JSON.parse(currentPreview[attribute]),
            null, 2
          );
        } catch(_) {
          object = currentPreview[attribute];
        }
        updateResult(`#${event.target.dataset.tabsTarget}`, object);
      }, 1)
    });
  };

  return consumer.subscriptions.create({ channel: 'PreviewChannel', id: id }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('PreviewChannel connected');

      initCodeMirrorOnTabsClick('#source-data-label', 'raw_data')
      initCodeMirrorOnTabsClick('#harvested-attributes-label', 'harvested_attributes')
      initCodeMirrorOnTabsClick('#api-record-label', 'api_record')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log('PreviewChannel disconnected')
    },
    received(data) {
      currentPreview = data;
      // Called when there's incoming data on the websocket for this channel
      console.log('PreviewChannel received')
      $('#preview-area-spinner').hide();
      $('#status').html(data.status);

      updateResult('#harvested-attributes', JSON.stringify(JSON.parse(data.harvested_attributes), null, 2));

      if(data.field_errors != null && data.field_errors != '{}') {
        $('#status').html("Field Errors");
        $('#field-errors').show();
        $('#field-errors textarea').val(JSON.stringify(JSON.parse(data.field_errors), null, 4));
        $('#field-errors .CodeMirror').remove();
        window.initCodeMirror(document.querySelector('#field-errors textarea'));
      }

      if(data.deletable === true) {
        $('#record-to-delete').show();
      }

      if(data.validation_errors) {
        $('#status').html('Validation Errors');

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

      if(data.status == 'finished' && data.raw_data == null) {
        $('h4.not-found').show();
      }
    }
  });
}

export default PreviewChannel;