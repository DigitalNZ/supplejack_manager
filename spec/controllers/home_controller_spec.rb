require "spec_helper"

describe HomeController do

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "GET index" do
    before(:each) do
      AbstractJob.stub(:find) { {} }
      CollectionStatistics.stub(:first) { double(:stats) }
      CollectionStatistics.stub(:index_statistics) { {"2013-12-26"=>{:suppressed=>1, :activated=>2, :deleted=>3}} }
      Parser.stub_chain(:desc, :limit)
      HarvestSchedule.stub(:find)
    end

    context "#set environment" do
      it "sets the environment to first available environment" do
        get :index
        controller.params[:environment].should eq APPLICATION_ENVS.first.to_s
      end

      it "sets the environment to staging if set" do
        get :index, environment: 'staging'
        controller.params[:environment].should eq 'staging'
      end
    end

    context "jobs" do
      context "successful query" do
        before(:each) do
          AbstractJob.should_receive(:find).with(:all, hash_including(:from)).exactly(3).times { [1,2,3] }
        end

        it "sets the count of active jobs" do
          get :index
          assigns(:stats)[:active_jobs].should eq 3
        end

        it "sets the count of finished jobs" do
          get :index
          assigns(:stats)[:finished_jobs].should eq 3
        end

        it "sets the count of failed jobs" do
          get :index
          assigns(:stats)[:failed_jobs].should eq 3
        end

      end
      context "error thrown" do
        it "sets the counts to n/a when exceptions occour" do
          AbstractJob.stub(:find).and_raise(StandardError.new)
          get :index
          assigns(:stats)[:failed_jobs].should eq 'n/a'
        end

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
        assigns(:stats)[:activated].should eq 'n/a'
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