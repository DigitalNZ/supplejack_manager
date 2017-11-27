# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require "spec_helper"

describe HomeController do

  before(:each) do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe "GET index", :caching => true do
    before(:each) do
      allow(AbstractJob).to receive(:find) { {} }
      allow(CollectionStatistics).to receive(:first) { double(:stats) }
      allow(CollectionStatistics).to receive(:index_statistics) { {"2013-12-26"=>{:suppressed=>1, :activated=>2, :deleted=>3}} }
      allow(Parser).to receive_message_chain(:desc, :limit)
      allow(HarvestSchedule).to receive(:find)
    end

    context "#set environment" do
      it "sets the environment to first available environment" do
        get :index
        expect(controller.params[:environment]).to eq APPLICATION_ENVS.first.to_s
      end

      it "sets the environment to production and cache the environment" do
        get :index, environment: 'production'
        expect(controller.params[:environment]).to eq 'production'
        get :index
        expect(controller.params[:environment]).to eq 'production'
      end
    end

    context "jobs" do
      context "successful query" do
        before(:each) do
          expect(AbstractJob).to receive(:find).with(:all, hash_including(:from)).exactly(3).times { [1,2,3] }
        end

        it "sets the count of active jobs" do
          get :index
          expect(assigns(:stats)[:active_jobs]).to eq 3
        end

        it "sets the count of finished jobs" do
          get :index
          expect(assigns(:stats)[:finished_jobs]).to eq 3
        end

        it "sets the count of failed jobs" do
          get :index
          expect(assigns(:stats)[:failed_jobs]).to eq 3
        end

      end
      context "error thrown" do
        it "sets the counts to n/a when exceptions occour" do
          allow(AbstractJob).to receive(:find).and_raise(StandardError.new)
          get :index
          expect(assigns(:stats)[:failed_jobs]).to eq 'n/a'
        end

      end

    end

    context "collection statistics" do

      it "sets the count of reactivated records" do
        get :index
        expect(assigns(:stats)[:activated]).to eq 2
      end

      it "sets the count of suppressed records" do
        get :index
        expect(assigns(:stats)[:suppressed]).to eq 1
      end

      it "sets the count of deleted records" do
        get :index
        expect(assigns(:stats)[:deleted]).to eq 3
      end

      it "sets the counts to 0 when exceptions occour" do
        allow(CollectionStatistics).to receive(:index_statistics).and_raise(StandardError.new)
        get :index
        expect(assigns(:stats)[:activated]).to eq 'n/a'
      end

    end

    context "recently edited parsers" do
      let(:parsers) { [double(:parser)] }

      it "sets the list of recently edited parsers" do
        allow(Parser).to receive_message_chain(:desc, :limit) { parsers }
        get :index
        expect(assigns(:parsers)).to eq parsers
      end

      it "sets parsers to nil when exceptions occour" do
        allow(Parser).to receive(:desc).and_raise(StandardError.new)
        get :index
        expect(assigns(:parsers)).to be_nil
      end
    end

    context "next scheduled jobs" do
      let(:schedules) { [double(:schedule)] }

      it "sets the list of next scheduled jobs" do
        expect(HarvestSchedule).to receive(:find).with(:all, :from => :next) { schedules }
        get :index
        expect(assigns(:scheduled_jobs)).to eq schedules
      end

      it "sets scheduled_jobs to nil when exceptions occour" do
        allow(HarvestSchedule).to receive(:find).and_raise(StandardError.new)
        get :index
        expect(assigns(:scheduled_jobs)).to be_nil
      end
    end

    context "failures" do
      it "sets the flash message when an exception occours" do
        allow(HarvestSchedule).to receive(:find).and_raise(StandardError.new)
        expect(controller).to receive(:t).with('dashboard.error') { 'Error message' }
        get :index
        expect(flash.now[:alert]).to eq 'Error message'
      end
    end
  end
end
