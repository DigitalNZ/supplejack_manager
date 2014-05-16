# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe HarvestSchedulesHelper do

  describe "#harvest_schedule_frequency" do
    let(:harvest_schedule) { mock(:harvest_schedule, 
                                   frequency: 'monthly', 
                                   at_hour: '13', 
                                   at_minutes: '46', 
                                   cron: "46 13 1 * *") }

    it "should generate the text" do
      helper.harvest_schedule_frequency(harvest_schedule).should eq "monthly at 13:46 (46 13 1 * *)"
    end
  end

end