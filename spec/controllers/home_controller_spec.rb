require "spec_helper"

describe HomeController do

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "GET index" do
    before(:each) do
      AbstractJob.stub(:search) { {} }
      CollectionStatistics.stub(:first) { double(:stats) }
      CollectionStatistics.stub(:index_statistics) { {"2013-12-26"=>{:suppressed=>1, :activated=>2, :deleted=>3}} }
      Parser.stub_chain(:desc, :limit)
      HarvestSchedule.stub(:find)
    end

    context "#set environment" do
      it "sets the environment to production" do
        get :index
        controller.params[:environment].should eq 'production'
      end

      it "sets the environment to staging if set" do
        get :index, environment: 'staging'
        controller.params[:environment].should eq 'staging'
      end
    end

    context "jobs" do
      it "sets the count of active jobs" do
        AbstractJob.should_receive(:search).with(environment: 'production', status: 'active') { [1,2,3] }
        get :index
        assigns(:stats)[:active_jobs].should eq 3
      end

      it "sets the count of completed jobs" do
        AbstractJob.should_receive(:search).with(environment: 'production', status: 'completed') { [1,2,3,4] }
        get :index
        assigns(:stats)[:completed_jobs].should eq 4
      end

      it "sets the count of failed jobs" do
        AbstractJob.should_receive(:search).with(environment: 'production', status: 'failed') { [1,2,3,4,5] }
        get :index
        assigns(:stats)[:failed_jobs].should eq 5
      end

      it "sets the counts to 0 when exceptions occour" do
        AbstractJob.stub(:search).and_raise(StandardError.new)
        get :index
        assigns(:stats)[:failed_jobs].should eq 0
      end
    end

    context "collection statistics" do
      it "sets the count of reactivated records" do
        get :index
        assigns(:stats)[:activated].should eq 2
      end

      it "sets the count of suppressed records" do
        get :index
        assigns(:stats)[:suppressed].should eq 1
      end

      it "sets the count of deleted records" do
        get :index
        assigns(:stats)[:deleted].should eq 3
      end

      it "sets the counts to 0 when exceptions occour" do
        CollectionStatistics.stub(:index_statistics).and_raise(StandardError.new)
        get :index
        assigns(:stats)[:activated].should eq 0
      end
    end

    context "recently edited parsers" do
      let(:parsers) { [mock(:parser)] }

      it "sets the list of recently edited parsers" do
        Parser.stub_chain(:desc, :limit) { parsers }
        get :index
        assigns(:parsers).should eq parsers
      end

      it "sets parsers to nil when exceptions occour" do
        Parser.stub(:desc).and_raise(StandardError.new)
        get :index
        assigns(:parsers).should be_nil
      end
    end

    context "next scheduled jobs" do
      let(:schedules) { [mock(:schedule)] }

      it "sets the list of next scheduled jobs" do
        HarvestSchedule.should_receive(:find).with(:all, :from => :next) { schedules }
        get :index
        assigns(:scheduled_jobs).should eq schedules
      end

      it "sets scheduled_jobs to nil when exceptions occour" do
        HarvestSchedule.stub(:find).and_raise(StandardError.new)
        get :index
        assigns(:scheduled_jobs).should be_nil
      end
    end

    context "failures" do
      it "sets the flash message when an exception occours" do
        HarvestSchedule.stub(:find).and_raise(StandardError.new)
        controller.should_receive(:t).with('dashboard.error') { 'Error message' }
        get :index
        flash.now[:alert].should eq 'Error message'
      end
    end
  end
end