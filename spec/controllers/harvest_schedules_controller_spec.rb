# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe HarvestSchedulesController do

  let(:schedule) { mock_model(HarvestSchedule).as_null_object }
  let(:user) { mock_model(User, role: 'admin').as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe "PUT update_all" do
    it 'update the scheduled harvets' do
      HarvestSchedule.should_receive(:all) { [schedule] }
      schedule.should_receive(:update_attributes).with({ 'status' => 'paused' })

      put :update_all, environment: "staging", harvest_schedule: { status: 'paused' }
    end
  end

  describe "GET index" do
    before(:each) do
      schedule.stub(:status) { 'active' }
    end

    it "returns all harvest schedules" do
      HarvestSchedule.should_receive(:all) { [schedule] }
      get :index, environment: "staging"
      assigns(:harvest_schedules).should eq [schedule]
    end

    it "assigns recurrent and one_off schedules" do
      s1 = mock(:schedule, recurrent: true, next_run_at: DateTime.now, status: 'active' )
      s2 = mock(:schedyle, recurrent: false, start_time: DateTime.now, status: 'active' )
      HarvestSchedule.stub(:all) { [s1, s2] }
      get :index, environment: "staging"
      assigns(:recurrent_schedules).should eq [s1]
      assigns(:one_off_schedules).should eq [s2]
    end
  end
  
  describe "POST create" do
    before(:each) do
      HarvestSchedule.stub(:new) { schedule }
    end

    it "initializes a new harvest schedule" do
      HarvestSchedule.should_receive(:new).with({"cron" => "* * * * *"}) { schedule }
      post :create, harvest_schedule: {cron: "* * * * *"}, environment: "staging"
      assigns(:harvest_schedule).should eq schedule
    end

    it "should redirect to the index" do
      post :create, harvest_schedule: {cron: "* * * * *"}, environment: "staging"
      response.should redirect_to(environment_harvest_schedules_path("staging"))      
    end
  end

  describe "PUT Update" do
    before(:each) do
      HarvestSchedule.stub(:find).with("1") { schedule }
    end

    it "finds the harvest schedule" do
      HarvestSchedule.should_receive(:find).with("1") { schedule }
      put :update, id: 1, environment: "staging"
      assigns(:harvest_schedule).should eq schedule
    end

    it "should update the attributes" do
      schedule.should_receive(:update_attributes).with({"cron" => "1 1 1 1 1"})
      put :update, id: 1, harvest_schedule: {cron: "1 1 1 1 1"}, environment: "staging"
    end

    it "should redirect to the index" do
      put :update, id: 1, harvest_schedule: {cron: "* * * * *"}, environment: "staging"
      response.should redirect_to(environment_harvest_schedules_path("staging"))
    end
  end
end