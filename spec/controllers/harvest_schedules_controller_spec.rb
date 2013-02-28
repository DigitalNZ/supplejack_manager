require "spec_helper"

describe HarvestSchedulesController do

  let(:schedule) { mock_model(HarvestSchedule).as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "GET index" do
    it "returns all harvest schedules" do
      HarvestSchedule.should_receive(:all) { [schedule] }
      get :index
      assigns(:harvest_schedules).should eq [schedule]
    end

    it "assigns recurrent and one_off schedules" do
      s1 = mock(:schedule, recurrent: true)
      s2 = mock(:schedyle, recurrent: false)
      HarvestSchedule.stub(:all) { [s1, s2] }
      get :index
      assigns(:recurrent_schedules).should eq [s1]
      assigns(:one_off_schedules).should eq [s2]
    end
  end

  describe "#GET show" do
    
    it "finds the harvest schedule" do
      HarvestSchedule.should_receive(:find).with("1") { schedule }
      get :show, id: 1, format: "js"
      assigns(:harvest_schedule).should eq schedule
    end
  end
  
  describe "POST create" do
    before(:each) do
      HarvestSchedule.stub(:new) { schedule }
    end

    it "initializes a new harvest schedule" do
      HarvestSchedule.should_receive(:new).with({"cron" => "* * * * *"}) { schedule }
      post :create, harvest_schedule: {cron: "* * * * *"}
      assigns(:harvest_schedule).should eq schedule
    end

    it "should redirect to the index" do
      post :create, harvest_schedule: {cron: "* * * * *"}
      response.should redirect_to(harvest_schedules_path)      
    end
  end

  describe "PUT Update" do
    before(:each) do
      HarvestSchedule.stub(:find).with("1") { schedule }
    end

    it "finds the harvest schedule" do
      HarvestSchedule.should_receive(:find).with("1") { schedule }
      put :update, id: 1
      assigns(:harvest_schedule).should eq schedule
    end

    it "should update the attributes" do
      schedule.should_receive(:update_attributes).with({"cron" => "1 1 1 1 1"})
      put :update, id: 1, harvest_schedule: {cron: "1 1 1 1 1"}
    end

    it "should redirect to the index" do
      put :update, id: 1, harvest_schedule: {cron: "* * * * *"}
      response.should redirect_to(harvest_schedules_path)
    end
  end
end