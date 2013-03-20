require "spec_helper"

describe HarvestJobsController do

  let(:job) { mock_model(HarvestJob).as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "#GET show" do
    
    it "finds the harvest job" do
      HarvestJob.should_receive(:find).with("1") { job }
      get :show, id: 1, format: "js", environment: "staging"
      assigns(:harvest_job).should eq job
    end
  end
  
  describe "POST create" do
    before(:each) do
      HarvestJob.stub(:new) { job }
    end

    it "initializes a new harvest job" do
      HarvestJob.should_receive(:new).with({"strategy" => "xml", "file_name" => "youtube.rb"}) { job }
      post :create, harvest_job: {strategy: "xml", file_name: "youtube.rb"}, format: "js", environment: "staging"
      assigns(:harvest_job).should eq job
    end

    it "should save the harvest job" do
      job.should_receive(:save)
      post :create, harvest_job: {strategy: "xml", file_name: "youtube.rb"}, format: "js", environment: "staging"
    end
  end

  describe "PUT Update" do
    before(:each) do
      HarvestJob.stub(:find).with("1") { job }
    end

    it "finds the harvest job" do
      HarvestJob.should_receive(:find).with("1") { job }
      put :update, id: 1, format: "js", environment: "staging"
      assigns(:harvest_job).should eq job
    end

    it "should update the attributes" do
      job.should_receive(:update_attributes).with({"status" => "finished"})
      put :update, id: 1, harvest_job: {status: "finished"}, format: "js", environment: "staging"
    end
  end
end