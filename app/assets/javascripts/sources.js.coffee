
fold_create_fields = (select, fields) ->
  if $(select).val() == ""
    $(fields).show()
    $(fields + ' input').attr('disabled', false)
    $(fields + ' select').attr('disabled', false)
  else
    $(fields).hide()
    $(fields + ' input').attr('disabled', true)
    $(fields + ' select').attr('disabled', true)

$ ->
  $('#sources').dataTable()

  fold_create_fields('#source_partner_id', '#new-partner-fields')
  
  $('#source_partner_id').change ->
    fold_create_fields('#source_partner_id', '#new-partner-fields')
  
  update_link = -> 
    time_ago = $( "#date-slider" ).slider( "value" )
    env = $('#environment').val()
    link = $('#reindex-button').attr('data-url')
    if time_ago != 0
      time_ago_ms = time_ago * 5 * 60 * 1000
      now = new Date()
      new_date = new Date(now - time_ago_ms)
      $('#reindex-button').attr('href', link + "?env=" + env + "&date=" + new_date.toISOString())
    else
      $('#reindex-button').attr('href', link + "?env=" + env)
  
  update_time = ->
    time_ago = $( "#date-slider" ).slider( "value" )
    if time_ago == 0
      $('#time').html('All records')
    else
      time_ago_ms = time_ago * 5 * 60 * 1000
      now = new Date()
      new_date = new Date(now - time_ago_ms)
      $('#time').html(moment().diff(moment(new_date), 'minutes') + " minutes ago (" + moment(new_date).format("hh:mm A")+")")
    update_link()

  $( "#date-slider" ).slider({
      orientation: "horizontal",
      range: "min",
      max: 49,
      value: 0,
      slide: update_time,
      change: update_time
    });

  $('#environment').change -> 
    update_link()

  update_link() if $( "#date-slider" ).length != 0