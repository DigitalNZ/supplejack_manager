require "spec_helper"

describe AbstractJobsController do

  let(:job) { mock_model(AbstractJob).as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "GET index" do
    it "returns active abstract jobs" do
      AbstractJob.should_receive(:search).with(hash_including("status" => "active"))
      get :index, status: "active", environment: "staging"
    end
  end
end