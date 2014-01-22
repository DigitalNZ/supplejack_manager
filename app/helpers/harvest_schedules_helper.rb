module HarvestSchedulesHelper
  def harvest_schedule_frequency(harvest_schedule)
    "#{harvest_schedule.frequency} at #{harvest_schedule.at_hour.to_s.rjust(2, "0")}:#{harvest_schedule.at_minutes.to_s.rjust(2, "0")} (#{harvest_schedule.cron})"
  end
end
