document.addEventListener('turbo:load', function() {
  let harvest_modal_content = $('#harvest-modal').html();
  let enrichment_modal_content = $('#enrichment-modal').html();

  $('#harvest-modal').on('closed.zf.reveal', function() {
    $('#harvest-modal').html(harvest_modal_content)
  })

  $('#enrichment-modal').on('closed.zf.reveal', function() {
    $('#enrichment-modal').html(enrichment_modal_content)
  })
})
