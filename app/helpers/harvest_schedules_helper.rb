# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

module HarvestSchedulesHelper
  def harvest_schedule_frequency(harvest_schedule)
    "#{harvest_schedule.frequency} at #{harvest_schedule.at_hour.to_s.rjust(2, "0")}:#{harvest_schedule.at_minutes.to_s.rjust(2, "0")} (#{harvest_schedule.cron})"
  end

  def pause_resume_class_for(schedule)
    schedule.status == 'active' ? 'pause' : 'resume'
  end

  def pause_resume_value_for(schedule)
    schedule.status == 'active' ? 'paused' : 'active'
  end
end
