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
