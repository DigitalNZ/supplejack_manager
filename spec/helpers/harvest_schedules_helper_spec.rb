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