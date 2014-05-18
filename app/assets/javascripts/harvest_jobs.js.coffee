# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

$ ->  
  $harvestJob = $("#harvest-job")
  if $harvestJob.length > 0 && $harvestJob.data("active")
    HarvestJobsPoller.poll()
  $('[name="harvest_job[mode]"]').change ->
    box = $('#harvest_job_limit')
    if $('#harvest_job_mode_full_and_flush')[0].checked
      box.attr('value', '')
      box.attr('disabled','disabled')
    else
      box.removeAttr('disabled')

@HarvestJobsPoller =
  poll: ->
    setTimeout @request, 2000

  request: ->
    $.get($("#harvest-job").data('url') + ".js")

